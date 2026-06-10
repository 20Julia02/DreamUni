from flask import Flask, request, jsonify
from flask_cors import CORS
import re
import psycopg2
import psycopg2.extras

app = Flask(__name__)
CORS(app)

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "dreamuni",
    "user": "postgres",
    "password": "Stanska",
}

DEFAULT_IMAGE = "https://images.unsplash.com/photo-1562774053-701939374585?auto=format&fit=crop&w=900&q=80"


def get_conn():
    return psycopg2.connect(**DB_CONFIG)


def split_values(value):
    """Dzieli wartości typu: 'polski, angielski' / 'polski; angielski'."""
    if not value:
        return []

    parts = re.split(r"[,;/|]+", str(value))
    result = []
    seen = set()

    for part in parts:
        cleaned = re.sub(r"\s+", " ", part).strip()
        if not cleaned:
            continue

        key = cleaned.casefold()
        if key not in seen:
            seen.add(key)
            result.append(cleaned)

    return result


def rank_min_from_value(value):
    """Zwraca początek zakresu rankingu, np. '1001-1200' -> 1001, '448' -> 448."""
    if value is None:
        return None

    match = re.search(r"\d+", str(value))
    return int(match.group(0)) if match else None


def rank_max_from_value(value):
    """Zwraca koniec zakresu rankingu, np. '1001-1200' -> 1200, '448' -> 448."""
    if value is None:
        return None

    matches = re.findall(r"\d+", str(value))
    return int(matches[-1]) if matches else None


@app.get("/health")
def health():
    return jsonify({"status": "ok"})


@app.get("/universities")
def universities():
    """
    Zwraca uczelnie jako GeoJSON FeatureCollection.

    Backend jest dostosowany do nowego CSV / nowej tabeli, gdzie dane są już po polsku:
      - country: Polska nazwa kraju, np. 'Niemcy'
      - region: 'Europa'
      - name: polska/oficjalna nazwa uczelni, np. 'Uniwersytet Oksfordzki'
      - teaching_languages: polskie nazwy języków, np. 'niemiecki, angielski'
      - city: oryginalna nazwa miasta, bez tłumaczenia
    """
    country = request.args.get("country", type=str)
    language = request.args.get("language", type=str)
    query = request.args.get("query", type=str)
    rank_from = request.args.get("rank_from", type=int)
    rank_to = request.args.get("rank_to", type=int)
    if rank_from is not None and rank_to is not None and rank_from > rank_to:
        rank_from, rank_to = rank_to, rank_from

    where = [
        "latitude IS NOT NULL",
        "longitude IS NOT NULL",
        "latitude BETWEEN -90 AND 90",
        "longitude BETWEEN -180 AND 180",
    ]
    params = {}

    if country:
        where.append("country = %(country)s")
        params["country"] = country

    if language:
        where.append("teaching_languages ILIKE %(language)s")
        params["language"] = f"%{language}%"

    if query:
        where.append(
            """
            (
                name ILIKE %(query)s OR
                description ILIKE %(query)s OR
                country ILIKE %(query)s OR
                city ILIKE %(query)s OR
                teaching_languages ILIKE %(query)s OR
                institution_profile ILIKE %(query)s
            )
            """
        )
        params["query"] = f"%{query}%"

    if rank_from is not None:
        where.append("qs_rank_max >= %(rank_from)s")
        params["rank_from"] = rank_from

    if rank_to is not None:
        where.append("qs_rank_min <= %(rank_to)s")
        params["rank_to"] = rank_to

    sql = f"""
        WITH ranked AS (
            SELECT
                universities.*,
                NULLIF(
                    regexp_replace(
                        split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 1),
                        '[^0-9]',
                        '',
                        'g'
                    ),
                    ''
                )::integer AS qs_rank_min,
                COALESCE(
                    NULLIF(
                        regexp_replace(
                            split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 2),
                            '[^0-9]',
                            '',
                            'g'
                        ),
                        ''
                    )::integer,
                    NULLIF(
                        regexp_replace(
                            split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 1),
                            '[^0-9]',
                            '',
                            'g'
                        ),
                        ''
                    )::integer
                ) AS qs_rank_max
            FROM universities
        )
        SELECT
            id,
            qs_rank,
            qs_rank_min,
            qs_rank_max,
            country_territory,
            region,
            name,
            description,
            country,
            city,
            latitude,
            longitude,
            website,
            image_url,
            institution_profile,
            teaching_languages
        FROM ranked
        WHERE {' AND '.join(where)}
        ORDER BY qs_rank_min NULLS LAST, name;
    """

    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
    finally:
        conn.close()

    features = []
    for row in rows:
        rank_min = row["qs_rank_min"] or rank_min_from_value(row["qs_rank"])
        rank_max = row["qs_rank_max"] or rank_max_from_value(row["qs_rank"])
        rank_raw = str(row["qs_rank"]).strip() if row["qs_rank"] is not None else ""

        properties = {
            "id": row["id"],
            "name": row["name"],
            "rank": rank_raw or None,
            "rank_min": rank_min,
            "rank_max": rank_max,
            "rank_label": f"Ranking QS: {rank_raw}" if rank_raw else "Ranking QS: brak danych",
            "description": row["description"],
            "country": row["country"],
            "country_pl": row["country"],
            "city": row["city"],
            "region": row["region"],
            "website": row["website"],
            "image_url": row["image_url"] or DEFAULT_IMAGE,
            "institution_profile": row["institution_profile"],
            "teaching_languages": row["teaching_languages"],
            "teaching_languages_pl": row["teaching_languages"],
        }

        features.append({
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [float(row["longitude"]), float(row["latitude"])],
            },
            "properties": properties,
        })

    return jsonify({"type": "FeatureCollection", "features": features})


@app.get("/meta")
def meta():
    """Zwraca kraje, pasujące języki i granice rankingu do filtrów."""
    country = request.args.get("country", type=str)
    sql = """
        SELECT
            ARRAY(
                SELECT DISTINCT country
                FROM universities
                WHERE country IS NOT NULL AND TRIM(country) <> ''
                ORDER BY country
            ) AS countries,
            ARRAY(
                SELECT DISTINCT teaching_languages
                FROM universities
                WHERE teaching_languages IS NOT NULL
                  AND TRIM(teaching_languages) <> ''
                  AND (%(country)s IS NULL OR country = %(country)s)
                ORDER BY teaching_languages
            ) AS teaching_languages,
            MIN(
                NULLIF(
                    regexp_replace(
                        split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 1),
                        '[^0-9]',
                        '',
                        'g'
                    ),
                    ''
                )::integer
            ) AS rank_min,
            MAX(
                COALESCE(
                    NULLIF(
                        regexp_replace(
                            split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 2),
                            '[^0-9]',
                            '',
                            'g'
                        ),
                        ''
                    )::integer,
                    NULLIF(
                        regexp_replace(
                            split_part(regexp_replace(qs_rank::text, '[–—]', '-', 'g'), '-', 1),
                            '[^0-9]',
                            '',
                            'g'
                        ),
                        ''
                    )::integer
                )
            ) AS rank_max
        FROM universities;
    """

    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, {"country": country})
            row = cur.fetchone()
    finally:
        conn.close()

    countries = [
        {"value": country, "label": country}
        for country in (row["countries"] or [])
    ]

    language_map = {}
    for raw_languages in row["teaching_languages"] or []:
        for language in split_values(raw_languages):
            language_map[language.casefold()] = language

    languages = [
        {"value": language, "label": language[:1].upper() + language[1:]}
        for language in language_map.values()
    ]

    countries.sort(key=lambda item: item["label"].casefold())
    languages.sort(key=lambda item: item["label"].casefold())

    return jsonify({
        "countries": countries,
        "languages": languages,
        "rank_min": row["rank_min"],
        "rank_max": row["rank_max"],
    })


@app.get("/debug/universities-columns")
def debug_universities_columns():
    """Pomocniczy endpoint do sprawdzenia, jakie kolumny faktycznie ma tabela universities."""
    sql = """
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_name = 'universities'
        ORDER BY ordinal_position;
    """

    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql)
            rows = cur.fetchall()
    finally:
        conn.close()

    return jsonify(rows)


@app.get("/partners")
def partners():
    """
    Zwraca partnerów dla danego kraju + globalnych (country = NULL).
    """
    country = request.args.get("country", type=str)

    sql = """
        SELECT id, name, category, icon, url, description
        FROM partners
        WHERE country = %(country)s OR country IS NULL
        ORDER BY country NULLS LAST, category, name;
    """

    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, {"country": country})
            rows = cur.fetchall()
    finally:
        conn.close()

    return jsonify([dict(r) for r in rows])


@app.get("/dormitories")
def dormitories():
    """
    Zwraca akademiki dla danej uczelni.
    """
    university_id = request.args.get("university_id", type=int)
    if not university_id:
        return jsonify([])

    sql = """
        SELECT id, name, latitude, longitude
        FROM dormitories
        WHERE university_id = %(uid)s;
    """

    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, {"uid": university_id})
            rows = cur.fetchall()
    finally:
        conn.close()

    return jsonify([dict(r) for r in rows])

if __name__ == "__main__":
    app.run(debug=True)
