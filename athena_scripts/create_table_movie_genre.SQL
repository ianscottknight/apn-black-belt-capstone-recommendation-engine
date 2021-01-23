with movie_genre AS 
    (SELECT movieId, genre
    FROM movies_parquet mp
    CROSS JOIN unnest(split(genres, '|')) AS mp(genre) ), genres_significant AS 
    (SELECT genre
    FROM movie_genre
    GROUP BY  genre
    HAVING count(*) > 1 ), genres_significant_indexed AS
    (select genre, ROW_NUMBER() over (order by genre asc) as row_index from genres_significant), movie_genre_indexed as 
    (select mg.movieId, gsi.row_index as genreId from movie_genre mg left join genres_significant_indexed gsi on mg.genre = gsi.genre order by movieId)
SELECT *
FROM movie_genre_indexed