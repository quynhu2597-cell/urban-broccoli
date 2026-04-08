Select * from ResturantData

select order_id, isnull(rating,0)  as rating,order_time, price from ResturantData

UPDATE ResturantData //*định dạng*//
SET 
    item_name = UPPER(LEFT(item_name,1)) + LOWER(SUBSTRING(item_name,2,LEN(item_name))),
    category = UPPER(LEFT(category,1)) + LOWER(SUBSTRING(category,2,LEN(category))),
    order_type = UPPER(LEFT(order_type,1)) + LOWER(SUBSTRING(order_type,2,LEN(order_type))),
	day_of_week = UPPER(LEFT(day_of_week,1)) + LOWER(SUBSTRING(day_of_week,2,LEN(day_of_week)))

UPDATE ResturantData
SET order_time = '00:00:00'
WHERE order_time IS NULL

UPDATE ResturantData
SET rating = (
    SELECT AVG(rating) FROM ResturantData WHERE rating IS NOT NULL
)
WHERE rating IS NULL

UPDATE ResturantData
SET quantity = 1
WHERE quantity<=0

SELECT item_name, COUNT(*) 
FROM ResturantData
WHERE price IS NULL
GROUP BY item_name

SELECT item_name, AVG(price)
FROM ResturantData
WHERE price IS NOT NULL
GROUP BY item_name

Update ResturantData
SET price=(
	Select AVG(price) from ResturantData where price is not null)
where price is null

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY order_date, item_name ORDER BY order_id) AS rn
    FROM ResturantData
)
DELETE FROM CTE WHERE rn > 1

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_date, item_name 
               ORDER BY order_id
           ) AS rn
    FROM ResturantData
)
SELECT * 
FROM CTE
WHERE rn > 1 //*lọc duplicate*//