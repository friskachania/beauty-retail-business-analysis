CREATE FUNCTION data_quality_audit()
RETURNS TABLE(
col_name text,
missing_count bigint,
missing_pct numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
r RECORD;
sql_text TEXT='';
BEGIN

FOR r IN
SELECT
c.column_name,
c.data_type
FROM information_schema.columns c
WHERE c.table_name='beauty_box_sales_raw'
LOOP

sql_text :=
sql_text ||

CASE
WHEN r.data_type IN
('character varying','varchar','text','char')
THEN

'SELECT
'''||r.column_name||''',
COUNT(*),
ROUND(
COUNT(*)*100.0/
(SELECT COUNT(*) FROM beauty_box_sales_raw),
2
)
FROM beauty_box_sales_raw
WHERE '
||r.column_name||
' IS NULL
OR TRIM('||r.column_name||')=''''
UNION ALL '

ELSE

'SELECT
'''||r.column_name||''',
COUNT(*),
ROUND(
COUNT(*)*100.0/
(SELECT COUNT(*) FROM beauty_box_sales_raw),
2
)
FROM beauty_box_sales_raw
WHERE '
||r.column_name||
' IS NULL
UNION ALL '

END;

END LOOP;

sql_text :=
LEFT(sql_text,LENGTH(sql_text)-10);

RETURN QUERY EXECUTE sql_text;

END;
$$;

SELECT *
FROM data_quality_audit()
WHERE missing_count > 0
ORDER BY missing_pct DESC;

