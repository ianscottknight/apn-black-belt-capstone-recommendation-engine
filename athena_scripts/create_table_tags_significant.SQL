WITH tags_lower AS 
    (SELECT lower(tag) AS tag
    FROM tags_parquet), tags_parquet_lower AS 
    (SELECT userId,
         movieId,
         lower(tag) AS tag,
         timestamp
    FROM tags_parquet ), tags_lower_significant AS 
    (SELECT tag
    FROM tags_lower
    GROUP BY tag
    HAVING count(*) > 1 ), tags_lower_significant_indexed as 
    (select tag, ROW_NUMBER() over (order by tag asc) as row_index from tags_lower_significant),
    
    tags_parquet_lower_significant AS 
    (SELECT userId, movieId, tpl.tag, tlsi.row_index as tagId, timestamp
    FROM tags_parquet_lower tpl
    LEFT JOIN tags_lower_significant_indexed tlsi
        ON tlsi.tag = tpl.tag
    WHERE tlsi.tag IS NOT NULL )
SELECT *
FROM tags_parquet_lower_significant