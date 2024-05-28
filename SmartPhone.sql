SELECT * 
FROM smartphone
WHERE processor_speed IS NULL;


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

--Which Smartphones have Memory capacity greater than or equal to 128GB average battery 
SELECT model, AVG(internal_memory) AS avg_internal_memory, AVG (battery_capacity) AS avg_battery_capacity
FROM smartphone
GROUP BY model
HAVING AVG(internal_memory) >= 128;

--Calculate the total cost of purchasing all smartphones with 5G connectivity--
SELECT SUM(price) AS cost
FROM smartphone
WHERE has_5g = 1;

--Create a new column indicating whether a smartphone has a high refresh rate display (e.g., > 90 Hz).--
ALTER TABLE smartphone
ADD refresh_rate_display VARCHAR(10);

UPDATE smartphone
SET refresh_rate_display = CASE
    WHEN refresh_rate >= 90 THEN 'High refresh rate'
    ELSE 'Low refresh rate'
END;

--Calculate the total RAM capacity across all smartphone models.--

SELECT DISTINCT brand_name,SUM(ram_capacity) AS total_RAM_Capacity
FROM smartphone
GROUP BY brand_name
ORDER BY total_RAM_Capacity DESC;
----
SELECT DISTINCT model,SUM(ram_capacity) AS total_RAM_Capacity
FROM smartphone
GROUP BY model
ORDER BY total_RAM_Capacity DESC;

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


SELECT *
FROM smartphone