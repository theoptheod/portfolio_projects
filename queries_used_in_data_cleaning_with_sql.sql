DROP TABLE IF EXISTS nashville_housing;
CREATE TABLE nashville_housing(
unique_id INT,
parcel_id VARCHAR(16),
land_use VARCHAR(42),
property_address VARCHAR(42),
sale_date TIMESTAMP,
sale_price INT,
legal_reference VARCHAR(17),
sold_as_vacant VARCHAR(3),
owner_name VARCHAR(60),
owner_address VARCHAR(46),
acreage NUMERIC(6,2),
tax_district VARCHAR(25),
land_value INT,
building_value INT,
total_value INT,
year_built INT,
bedrooms INT,
full_bath INT,
half_bath INT
);

--Altering the datatype of column sale_date from TIMESTAMP to DATE.
ALTER TABLE public.nashville_housing
ALTER COLUMN sale_date TYPE DATE;

--Populate the NULL values of the property_address column.
SELECT
*
FROM public.nashville_housing
WHERE property_address IS NULL;

--We update the property_address column using WHERE to filter the properties with no address.
UPDATE public.nashville_housing AS nash_1
SET property_address = nash_2.property_address
FROM public.nashville_housing AS nash_2
WHERE nash_1.parcel_id = nash_2.parcel_id 
	AND nash_1.unique_id != nash_2.unique_id
    AND nash_1.property_address IS NULL;

--Breaking column property_address into two columns (address and city) to increase usability.
--Using SPLIT_PART().
SELECT
property_address,
SPLIT_PART(property_address, ',',  1),
SPLIT_PART(property_address, ',',  2)
FROM public.nashville_housing;

--Use LENGTH() to find the max length of the strings in the two new columns
--in order to have the correct datatype when adding them in the table.
WITH cte_len_string
AS(
SELECT
LENGTH(SPLIT_PART(property_address, ',',  1)) AS len_string_address,
LENGTH(SPLIT_PART(property_address, ',',  2)) AS len_string_city
FROM public.nashville_housing
)
SELECT
MAX(len_string_address),
MAX(len_string_city)
FROM cte_len_string;

--Having found the max length of the strings we create two new columns.
ALTER TABLE public.nashville_housing
ADD property_split_address VARCHAR(31),
ADD property_split_city VARCHAR(15);

--Update the table.
UPDATE public.nashville_housing
SET property_split_address = SPLIT_PART(property_address, ',',  1),
property_split_city = SPLIT_PART(property_address, ',',  2);

--Breaking column owner_address into three columns (address,city and state) to increase usability.
--Using SUBSTRING() and POSITION() as an alternative to SPLIT_PART().
SELECT
owner_address,
SUBSTRING(owner_address, 1, POSITION(',' IN owner_address) -1),
SUBSTRING(owner_address, POSITION(',' IN owner_address) +1, LENGTH(SPLIT_PART(owner_address, ',',  2))),
SUBSTRING(owner_address, RIGHT(owner_address, 2))
FROM public.nashville_housing;

--Use LENGTH() to find the max length of the strings in the three new columns
--in order to have the correct datatype when adding them in the table.
WITH cte_len_string
AS(
SELECT
LENGTH(SUBSTRING(owner_address, 1, POSITION(',' IN owner_address) -1)) AS len_string_address,
LENGTH(SUBSTRING(owner_address, POSITION(',' IN owner_address) +1, LENGTH(SPLIT_PART(owner_address, ',',  2)))) AS len_string_city,
LENGTH(SUBSTRING(owner_address, RIGHT(owner_address, 2))) AS len_string_state
FROM public.nashville_housing
)
SELECT
MAX(len_string_address),
MAX(len_string_city),
MAX(len_string_state)
FROM cte_len_string;

--Having found the max length of the strings we create three new columns.
ALTER TABLE public.nashville_housing
ADD owner_split_address VARCHAR(30),
ADD owner_split_city VARCHAR(15),
ADD owner_split_state VARCHAR(2);

--Update the table.
UPDATE public.nashville_housing
SET owner_split_address = SUBSTRING(owner_address, 1, POSITION(',' IN owner_address) -1),
owner_split_city = SUBSTRING(owner_address, POSITION(',' IN owner_address) +1, LENGTH(SPLIT_PART(owner_address, ',',  2))),
owner_split_state = SUBSTRING(owner_address, RIGHT(owner_address, 2));

--Change Y and N to Yes and No in column sold_as_vacant.
SELECT
sold_as_vacant,
CASE
	WHEN sold_as_vacant = 'Y' THEN 'Yes'
	WHEN sold_as_vacant = 'Yes' THEN 'Yes'
	WHEN sold_as_vacant = 'N' THEN 'No'
	WHEN sold_as_vacant = 'No' THEN 'No'
END
FROM public.nashville_housing;

UPDATE public.nashville_housing
SET sold_as_vacant = 
CASE
	WHEN sold_as_vacant = 'Y' THEN 'Yes'
	WHEN sold_as_vacant = 'Yes' THEN 'Yes'
	WHEN sold_as_vacant = 'N' THEN 'No'
	WHEN sold_as_vacant = 'No' THEN 'No'
END;

--Remove duplicate lines.
--We find the rows that are duplicates using a CTE and the Window Function ROW_NUMBER().
WITH cte_del_dup
AS (
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY parcel_id,
				 property_address,
				 sale_price,
				 sale_date,
				 legal_reference
		ORDER BY unique_id) AS row_num
FROM public.nashville_housing)
SELECT
*
FROM cte_del_dup
WHERE row_num > 1;

--DELETE those rows using a CTE.
DELETE FROM public.nashville_housing
WHERE unique_id IN(
SELECT
unique_id
FROM(
SELECT
unique_id,
ROW_NUMBER() OVER(PARTITION BY parcel_id,
				property_address,
				sale_price,
				sale_date,
				legal_reference
		ORDER BY unique_id) AS row_num
FROM public.nashville_housing)
WHERE row_num > 1);

--DELETE unused columns.
ALTER TABLE public.nashville_housing
DROP COLUMN tax_district,
DROP COLUMN owner_address,
DROP COLUMN property_address;