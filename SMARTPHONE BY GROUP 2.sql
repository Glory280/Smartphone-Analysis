SELECT * 
FROM smartphone
WHERE processor_brand IS NULL;

--Data Cleaning ---
--Replace the null values in rating with average rating--
UPDATE smartphone
SET rating = (
    SELECT AVG(rating)
    FROM smartphone
    WHERE rating IS NOT NULL
)
WHERE rating IS NULL;

--Replace the null values in num_cores with average num_cores--
UPDATE smartphone
SET num_cores = (
    SELECT CAST(AVG(CAST(num_cores AS FLOAT)) AS INT)
    FROM smartphone
    WHERE ISNUMERIC(num_cores) = 1 AND num_cores IS NOT NULL
)
WHERE num_cores IS NULL;

--Replace the null values in Processor_speed with average Processor_speed--
UPDATE smartphone
SET Processor_speed = (
    SELECT AVG(processor_speed)
    FROM smartphone
    WHERE Processor_speed IS NOT NULL)
WHERE processor_speed IS NULL;

--Replace the null values in battery_capacity with average battery_capacity--
UPDATE smartphone
SET battery_capacity = (
    SELECT AVG(battery_capacity)
    FROM smartphone
    WHERE battery_capacity IS NOT NULL)
WHERE battery_capacity IS NULL;

--Replace the null values in internal_memory with average internal_memory--
UPDATE smartphone
SET internal_memory = (
    SELECT AVG(internal_memory)
    FROM smartphone
    WHERE internal_memory IS NOT NULL
	)
WHERE internal_memory IS NULL;

--Replace the null values in num_front_camerasy with num_front_cameras--
UPDATE smartphone
SET num_front_cameras = (
    SELECT AVG(num_front_cameras)
    FROM smartphone
    WHERE num_front_cameras  IS NOT NULL
	)
WHERE num_front_cameras  IS NULL;

--Replace the null values in internal_memory with average internal_memory--
UPDATE smartphone
SET num_front_cameras = (
    SELECT AVG(num_front_cameras)
    FROM smartphone
    WHERE num_front_cameras  IS NOT NULL
	)
WHERE num_front_cameras  IS NULL;

-- Data Retrieval --

-- What are the top 10 smartphone models by price?--
SELECT 
TOP 10 model, price
FROM smartphone
ORDER BY price DESC;

--Which brands offer smartphones with 5G connectivity?--
SELECT DISTINCT brand_name
FROM smartphone
WHERE has_5g = 1;

--How many smartphones have NFC capability?--
SELECT COUNT (DISTINCT model) AS NFC_smartphone
FROM smartphone
WHERE has_nfc = 1;

--What is the average battery capacity of smartphones?--
SELECT ROUND(AVG(battery_capacity), 0) AS average_battery_capacity
FROM smartphone

--Which smartphones have a processor speed greater than 2.5 GHz?--
SELECT model, ROUND (processor_speed,2) AS processor_speed
FROM smartphone
WHERE processor_speed > 2.5;

--Calculate the total cost of purchasing all smartphones with 5G connectivity--
SELECT  SUM(price) AS cost
FROM smartphone
WHERE has_5g = 1;

-- Total RAM capacity across all smartphone models by model --
SELECT DISTINCT model, SUM(ram_capacity) AS total_RAM_Capacity
FROM smartphone
GROUP BY model
ORDER BY total_RAM_Capacity DESC;

--What is the most common operating system used in smartphones?--
SELECT os, COUNT(*) AS Operating_System_Count
FROM smartphone
WHERE os IS NOT NULL
GROUP BY os;


--Which Smartphones have Memory capacity greater than or equal to 128GB average battery 
SELECT model, AVG(internal_memory) AS avg_internal_memory, AVG (battery_capacity) AS avg_battery_capacity
FROM smartphone
GROUP BY model
HAVING AVG(internal_memory) >= 128;

--Combine processor name and brand to create a new column representing the full processor specification.--
ALTER TABLE smartphone
ADD full_processor_specification VARCHAR(255); 

UPDATE smartphone
SET full_processor_specification = CONCAT(processor_name, ' - ', processor_brand);

--Which smartphone features (e.g., processor speed, RAM capacity) contribute most to price?--
SELECT ROUND(processor_speed, 2) AS processor_speed, ram_capacity, price
FROM smartphone
ORDER BY price DESC;

--Are smartphones with 5G connectivity generally more expensive than those without?--
SELECT TOP 20  brand_name, model, price, has_5g, processor_speed, ram_capacity
FROM smartphone
ORDER BY  price DESC;

--How does the number of rear cameras affect the overall rating of smartphones?--
SELECT 
    brand_name,
    model,
    rating,
    num_rear_cameras
FROM
    (
        SELECT
            brand_name,
            model,
            AVG(rating) AS rating,
            num_rear_cameras
        FROM
            smartphone
        GROUP BY
            brand_name,
            model,
            num_rear_cameras
    ) AS subquery
ORDER BY
    num_rear_cameras DESC;

--Does the presence of an IR blaster influence the popularity of a smartphone model?--
SELECT model, AVG(rating) AS Rating
FROM smartphone
WHERE has_ir_blaster = 1
GROUP BY model
ORDER BY Rating DESC;

-- What is the distribution of smartphone prices? --

  WITH PriceRangeCount AS (
  SELECT
    CASE 
      WHEN price < 20000 THEN '< 20000'
      WHEN price BETWEEN 20000 AND 49999 THEN '20000-49999'
      WHEN price BETWEEN 50000 AND 99999 THEN '50000-99999'
      WHEN price BETWEEN 100000 AND 199999 THEN '100000-199999'
      WHEN price BETWEEN 200000 AND 399999 THEN '200000-399999'
      ELSE '400000 and above'
    END AS price_range,
    COUNT(*) AS num_smartphones
  FROM smartphone
  GROUP BY
    CASE 
      WHEN price < 20000 THEN '< 20000'
      WHEN price BETWEEN 20000 AND 49999 THEN '20000-49999'
      WHEN price BETWEEN 50000 AND 99999 THEN '50000-99999'
      WHEN price BETWEEN 100000 AND 199999 THEN '100000-199999'
      WHEN price BETWEEN 200000 AND 399999 THEN '200000-399999'
      ELSE '400000 and above'
    END
)
SELECT
  s.model,
  prc.price_range,
  prc.num_smartphones
FROM smartphone s
INNER JOIN PriceRangeCount prc
ON CASE 
      WHEN s.price < 20000 THEN '< 20000'
      WHEN s.price BETWEEN 20000 AND 49999 THEN '20000-49999'
      WHEN s.price BETWEEN 50000 AND 99999 THEN '50000-99999'
      WHEN s.price BETWEEN 100000 AND 199999 THEN '100000-199999'
      WHEN s.price BETWEEN 200000 AND 399999 THEN '200000-399999'
      ELSE '400000 and above'
   END = prc.price_range
ORDER BY
  CASE 
    WHEN prc.price_range = '< 20000' THEN 1
    WHEN prc.price_range = '20000-49999' THEN 2
    WHEN prc.price_range = '50000-99999' THEN 3
    WHEN prc.price_range = '100000-199999' THEN 4
    WHEN prc.price_range = '200000-399999' THEN 5
    ELSE 6
  END;


--How does the average battery capacity vary among different brands?--
SELECT brand_name, ROUND(AVG(battery_capacity), 0) AS avg_battery_capacity
FROM smartphone
GROUP BY brand_name

