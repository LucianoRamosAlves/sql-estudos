-- trasforme um valor de um tipo para outro
SELECT CAST('123' AS SIGNED); -- 123

SELECT CAST(123 AS CHAR) AS texto; -- '123'

SELECT CAST(NOW() AS TIME) AS hora; -- '12:00:00' , remove a data da query