-- see the rows with duplicate values
SELECT 
    *, 
    COUNT(*) 
FROM 
    dbo.new_retail_data 
GROUP BY 
    Transaction_ID, Customer_ID, Name, Email, Phone, Address, City, State, Zipcode, Country, Age, Gender, Income, 
    Customer_Segment, Date, Year, Month, Time, Total_Purchases, Amount, Total_Amount, Product_Category, 
    Product_Brand, Product_Type, Feedback, Shipping_Method, Payment_Method, Order_Status, Ratings, products 
HAVING 
    COUNT(*) > 1;


-- detailed rows with duplicate values
	SELECT *
FROM dbo.new_retail_data
WHERE CONCAT(Customer_ID, '|', Name, '|', Email, '|', Phone, '|', Address, '|', City, '|', State, '|', Zipcode, '|', Country, '|', Age, '|', Gender, '|', Income, '|',
             Customer_Segment, '|', Date, '|', Year, '|', Month, '|', Time, '|', Total_Purchases, '|', Amount, '|', Total_Amount, '|', Product_Category, '|',
             Product_Brand, '|', Product_Type, '|', Feedback, '|', Shipping_Method, '|', Payment_Method, '|', Order_Status, '|', Ratings, '|', products)
IN (
    SELECT CONCAT(Customer_ID, '|', Name, '|', Email, '|', Phone, '|', Address, '|', City, '|', State, '|', Zipcode, '|', Country, '|', Age, '|', Gender, '|', Income, '|',
                  Customer_Segment, '|', Date, '|', Year, '|', Month, '|', Time, '|', Total_Purchases, '|', Amount, '|', Total_Amount, '|', Product_Category, '|',
                  Product_Brand, '|', Product_Type, '|', Feedback, '|', Shipping_Method, '|', Payment_Method, '|', Order_Status, '|', Ratings, '|', products)
    FROM dbo.new_retail_data
    GROUP BY Customer_ID, Name, Email, Phone, Address, City, State, Zipcode, Country, Age, Gender, Income,
             Customer_Segment, Date, Year, Month, Time, Total_Purchases, Amount, Total_Amount, Product_Category, 
             Product_Brand, Product_Type, Feedback, Shipping_Method, Payment_Method, Order_Status, Ratings, products
    HAVING COUNT(*) > 1
);


-- see the no of rows in both condition
select * from dbo.new_retail_data;
select Distinct * from dbo.new_retail_data;

-- 1. Removing duplicate rows
SELECT DISTINCT *
INTO #temp_unique             -- Creating temporary table with unique values
FROM dbo.new_retail_data;

DELETE FROM dbo.new_retail_data;      -- Deleting data from original table  
INSERT INTO dbo.new_retail_data      -- Inserting unique data in original table
SELECT * FROM #temp_unique;

-- Initially the number of rows are 302010 with four repeated rows 
--but after removing duplicate rows, its now 302006.

-- 2. detecting same customer with multiple email ID

SELECT Customer_ID, COUNT(DISTINCT LOWER(Email)) AS Num_Emails
FROM dbo.new_retail_data
--where Customer_ID = 46774
GROUP BY Customer_ID
HAVING COUNT(DISTINCT LOWER(Email)) > 1
order by Customer_ID;


SELECT *
FROM dbo.new_retail_data
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM dbo.new_retail_data
	where Customer_ID = 10000
    GROUP BY Customer_ID
    HAVING COUNT(DISTINCT LOWER(Email)) > 1
);

--3. deleting customer id with null value
DELETE FROM dbo.new_retail_data
WHERE Customer_ID IS NULL;

--4. removing year and month column as date column is present here
ALTER TABLE dbo.new_retail_data
DROP COLUMN Year;
ALTER TABLE dbo.new_retail_data
DROP COLUMN Month;
ALTER TABLE dbo.new_retail_data
DROP COLUMN Zipcode;

select * from dbo.new_retail_data;

--5. Handling all null values in all columns
SELECT 
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
    SUM(CASE WHEN Email IS NULL THEN 1 ELSE 0 END) AS Null_Email,
    SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS Null_Phone,
    SUM(CASE WHEN Address IS NULL THEN 1 ELSE 0 END) AS Null_Address,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS Null_Income,
    SUM(CASE WHEN Customer_Segment IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Segment,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Null_Time,
    SUM(CASE WHEN Total_Purchases IS NULL THEN 1 ELSE 0 END) AS Null_Total_Purchases,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
    SUM(CASE WHEN Total_Amount IS NULL THEN 1 ELSE 0 END) AS Null_Total_Amount,
    SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS Null_Product_Category,
    SUM(CASE WHEN Product_Brand IS NULL THEN 1 ELSE 0 END) AS Null_Product_Brand,
    SUM(CASE WHEN Product_Type IS NULL THEN 1 ELSE 0 END) AS Null_Product_Type,
    SUM(CASE WHEN Feedback IS NULL THEN 1 ELSE 0 END) AS Null_Feedback,
    SUM(CASE WHEN Shipping_Method IS NULL THEN 1 ELSE 0 END) AS Null_Shipping_Method,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Null_Payment_Method,
    SUM(CASE WHEN Order_Status IS NULL THEN 1 ELSE 0 END) AS Null_Order_Status,
    SUM(CASE WHEN Ratings IS NULL THEN 1 ELSE 0 END) AS Null_Ratings,
    SUM(CASE WHEN Products IS NULL THEN 1 ELSE 0 END) AS Null_Products
FROM dbo.new_retail_data;


--updating null value in column by not provided

UPDATE dbo.new_retail_data
SET 
    Email = COALESCE(Email, 'not-provided'),
    Phone = COALESCE(Phone, 0000),
	Address = COALESCE(Address, 'not-provided'),
	City = COALESCE(City, 'not-provided'),
	State = COALESCE(State, 'not-provided'),
	Country = COALESCE(Country, 'not-provided'),
	Gender = COALESCE(Gender, 'not-provided'),
	Income = COALESCE(Income, 'not-provided'),
	Customer_Segment = COALESCE(Customer_Segment, 'not-provided'),
	Product_Category = COALESCE(Product_Category, 'not-specified'),
	Product_Brand = COALESCE(Product_Brand, 'not-specified'),
	Product_Type = COALESCE(Product_Type, 'not-specified'),
	Feedback = COALESCE(Feedback, 'not-provided'),
	Shipping_Method = COALESCE(Shipping_Method, 'not-specified'),
	Payment_Method = COALESCE(Payment_Method, 'not-specified'),
	Order_Status = COALESCE(Order_Status, 'not-specified'),
	Products = COALESCE(Products, 'not-specified')

WHERE 
    Email IS NULL OR 
	Address IS NULL OR
	City IS NULL OR
	State IS NULL OR
	Country IS NULL OR
	Gender IS NULL OR
	Income IS NULL OR
	Customer_Segment IS NULL OR
	Product_Category IS NULL OR
	Product_Brand IS NULL OR
	Product_Type IS NULL OR
	Feedback IS NULL OR
	Shipping_Method IS NULL OR
	Payment_Method IS NULL OR
	Order_Status IS NULL OR
	products IS NULL OR
    Phone IS NULL;


--6. filling avg age in age column at place of null values and
--removing rows having null value in either date, time or total purchages column 
--as it is approx just 0.35% of total rows.


UPDATE dbo.new_retail_data
SET Age = (
    SELECT ROUND(AVG(Age), 0)
    FROM dbo.new_retail_data
    WHERE Age IS NOT NULL
)
WHERE Age IS NULL;

select COUNT (*) from dbo.new_retail_data
where Date is NULL or Time is NULL or Total_Purchases IS NULL;

DELETE FROM dbo.new_retail_data
WHERE Date IS NULL OR Time IS NULL OR Total_Purchases IS NULL;

/*removing row where both the amount and total amount value is null, 
calculating amount by deviding total_amount by total_purchase
calculating total_amount by multiplying amount and total_purchase.*/
select * from dbo.new_retail_data
where Amount is NULL OR Total_Amount is NULL;

DELETE FROM dbo.new_retail_data
WHERE Amount IS NULL AND Total_Amount IS NULL;

UPDATE dbo.new_retail_data
SET Total_Amount = Amount * Total_Purchases
WHERE Total_Amount IS NULL AND Amount IS NOT NULL AND Total_Purchases IS NOT NULL;

UPDATE dbo.new_retail_data
SET Amount = Total_Amount / Total_Purchases
WHERE Amount IS NULL AND Total_Amount IS NOT NULL AND Total_Purchases IS NOT NULL;

--7. filling missing value in rating column by average value
select * from dbo.new_retail_data
where Ratings is NULL;

UPDATE dbo.new_retail_data
SET Ratings = (
    SELECT AVG(Ratings) 
    FROM dbo.new_retail_data 
    WHERE Ratings IS NOT NULL
)
WHERE Ratings IS NULL;
 
--8. Handling same customer id provided to multiple customers issue.
-- assigning new customer id for unique customer

--Creating a temporary table of unique customers
WITH UniqueCustomers AS (
  SELECT DISTINCT Name, Email, Phone,
         ROW_NUMBER() OVER (ORDER BY Name, Email, Phone) + 100000 AS NewID
  FROM dbo.new_retail_data)

 /*
 explanation:- with DISTINCT Name, Email, Phone, we will Gets all unique combinations of customer information.
ROW_NUMBER() OVER (...): Generates a unique sequential number (like 1, 2, 3...) for each unique customer.
+ 100000: Ensures all new Customer_IDs start from 100001 (to avoid overlapping with old IDs).
This creates a temporary table called UniqueCustomers, with columns: Name, Email, Phone and NewID
 */

-- Updating actual table using JOIN
UPDATE dbo.new_retail_data
SET Customer_ID = uc.NewID
FROM dbo.new_retail_data rd
JOIN UniqueCustomers uc
  ON rd.Name = uc.Name
     AND rd.Email = uc.Email
     AND rd.Phone = uc.Phone;

/*
explanation:- We're updating the Customer_ID in the original table retail_data.
It joins each row in retail_data with a corresponding row from UniqueCustomers 
based on matching Name, Email, and Phone.
Then sets the Customer_ID of that row to the new NewID generated earlier.
*/


--9. Detecting and Fixing Inconsistent Values in phone

SELECT *
FROM dbo.new_retail_data
WHERE Phone IN (
  SELECT Phone
  FROM dbo.new_retail_data
  GROUP BY Phone
  HAVING COUNT(DISTINCT Name) > 1 OR COUNT(DISTINCT Email) > 1 
)
order by Phone;

--It shows all the phone numbers are assigned to two customers. 
--i dont need phone number for analysing data so i prefer to drop it.

ALTER TABLE dbo.new_retail_data
DROP COLUMN Phone;

--10. handling duplicate transaction id
-- showing no of duplicate for each transaction id
SELECT Transaction_ID, COUNT(*)
FROM dbo.new_retail_data
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

-- checking if duplicate transaction id have exactly same details of transaction or different
SELECT *
FROM dbo.new_retail_data
WHERE Transaction_ID IN (
  SELECT Transaction_ID
  FROM dbo.new_retail_data
  GROUP BY Transaction_ID
  HAVING COUNT(*) > 1
)
order by Transaction_ID;

-- since the details are different so i need to keep all records. for this assigning new transaction id for each record.

--adding new auto-incrementing column, and Updating Transaction_ID based on this new number
ALTER TABLE dbo.new_retail_data ADD New_Transaction_Num INT IDENTITY(1,1);

ALTER TABLE dbo.new_retail_data
ALTER COLUMN Transaction_ID VARCHAR(50);

UPDATE dbo.new_retail_data
SET Transaction_ID = CONCAT('T', RIGHT('000000' + CAST(New_Transaction_Num AS VARCHAR(6)), 6));

ALTER TABLE dbo.new_retail_data
DROP COLUMN New_Transaction_Num;


--11. checking for same customer with Conflicting Order_Status

SELECT Customer_ID, Time, COUNT(DISTINCT Order_Status)
FROM dbo.new_retail_data
GROUP BY Customer_ID, Time
HAVING COUNT(DISTINCT Order_Status) > 1
;

--assigning most appropriate Order_status

--Assigning priority Order_Status
WITH StatusWithPriority AS (
    SELECT 
        Customer_ID,
        Date,
        Order_Status,
        CASE 
            WHEN Order_Status = 'Delivered' THEN 1
            WHEN Order_Status = 'Shipped' THEN 2
            WHEN Order_Status = 'Processing' THEN 3
            WHEN Order_Status = 'Pending' THEN 4
            WHEN Order_Status = 'not-specified' THEN 5
            ELSE 6 -- Catch unexpected statuses
        END AS Priority
    FROM dbo.new_retail_data
),

--Finding the Best Priority per Customer_ID + Date
BestPriorityStatus AS (
    SELECT 
        Customer_ID,
        Date,
        MIN(Priority) AS BestPriority
    FROM StatusWithPriority
    GROUP BY Customer_ID, Date
)

--Updating the data table with new order_status
UPDATE rd
SET rd.Order_Status = swp.Order_Status
FROM dbo.new_retail_data rd
INNER JOIN BestPriorityStatus bp
  ON rd.Customer_ID = bp.Customer_ID
 AND rd.Date = bp.Date
INNER JOIN StatusWithPriority swp
  ON swp.Customer_ID = bp.Customer_ID
 AND swp.Date = bp.Date
 AND swp.Priority = bp.BestPriority;

--finding exact duplicates after updating data 
 SELECT 
    Customer_ID, 
    Date,
    Total_Purchases,
    Amount,
    Total_Amount,
    COUNT(*) AS Duplicate_Count
FROM dbo.new_retail_data
GROUP BY 
    Customer_ID, 
    Date,
    Total_Purchases,
    Amount,
    Total_Amount
HAVING COUNT(*) > 1;

--deleting duplicates
WITH DuplicatesMarked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Customer_ID, Date, Total_Purchases, Amount, 
		   Total_Amount ORDER BY (SELECT NULL)) AS rn
    FROM dbo.new_retail_data
)
DELETE FROM DuplicatesMarked
WHERE rn > 1;


--12. Check Product/Brand Details

--Find Unique Brand Names (to spot inconsistencies)
SELECT DISTINCT Product_Brand
FROM dbo.new_retail_data
ORDER BY Product_Brand;

--Find Unique Product Categories
SELECT DISTINCT Product_Category
FROM dbo.new_retail_data
ORDER BY Product_Category;

-- everything looks good in this part so no need of cleaning in data.


--13. Check Payment and Shipping Details
SELECT *
FROM dbo.new_retail_data
WHERE Order_Status = 'Delivered'
  AND (
        Shipping_Method = 'not-specified' OR Payment_Method = 'not-specified' );

-- finding mostly used Payment Methods and shipping methods to set as default at place of not-specified
SELECT Payment_Method, COUNT(*) AS Count_Payment_Method
FROM dbo.new_retail_data
GROUP BY Payment_Method
ORDER BY Count_Payment_Method DESC;      -- credit card(88983), debit card(76125)

SELECT Shipping_Method, COUNT(*) AS Count_Shipping_Method
FROM dbo.new_retail_data
GROUP BY Shipping_Method
ORDER BY Count_Shipping_Method DESC;     -- same_day(103001), express(101113)

-- Updating payment method and shipping method with mostly used value at place of not specified
UPDATE dbo.new_retail_data
SET Payment_Method = 'Credit Card'
WHERE Payment_Method = 'not-specified';

UPDATE dbo.new_retail_data
SET Shipping_Method = 'Express'
WHERE Shipping_Method = 'not-specified';

--14. Checking for negative integer values and incorrect Total_Amount
SELECT *
FROM dbo.new_retail_data
WHERE 
    Total_Purchases < 0
    OR Amount < 0
    OR Total_Amount < 0
    OR Total_Amount <> Amount * Total_Purchases;

-- fixing the total_amount incorrect calculations
UPDATE dbo.new_retail_data
SET Total_Amount =(Amount * Total_Purchases)
WHERE (Total_Amount) <> (Amount * Total_Purchases);

select * from dbo.new_retail_data;


ALTER TABLE dbo.new_retail_data
ADD TimeN varchar(8);

UPDATE dbo.new_retail_data
SET TimeN = CONVERT(varchar(8), Time, 108);

ALTER TABLE dbo.new_retail_data
DROP COLUMN Time;

select DISTINCT Feedback from dbo.new_retail_data;


-- cteating dim and fact tables for start schema


-- dim_customer table

CREATE TABLE dim_customer (
    Customer_ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Country NVARCHAR(50),
    Age INT,
    Gender NVARCHAR(50),
    Income NVARCHAR(50),
    Customer_Segment NVARCHAR(50)
);

INSERT INTO dim_customer (
    Customer_ID, Name, Email, Address, City, State, Country,
	Age, Gender, Income, Customer_Segment
)
SELECT DISTINCT
    Customer_ID, Name, Email, Address, City, State, 
	Country, Age, Gender, Income, Customer_Segment
FROM dbo.new_retail_data
WHERE Customer_ID IS NOT NULL;

select * from dim_customer;

-- dim_product table

CREATE TABLE dim_product (
    Product_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_Category NVARCHAR(100),
    Product_Brand NVARCHAR(100),
    Product_Type NVARCHAR(100),
    Products NVARCHAR(100)
);

INSERT INTO dim_product (Product_Category, Product_Brand, Product_Type, Products)
SELECT DISTINCT 
    Product_Category,
    Product_Brand,
    Product_Type,
    Products
FROM dbo.new_retail_data
WHERE 
    Product_Category IS NOT NULL AND
    Product_Brand IS NOT NULL AND
    Product_Type IS NOT NULL AND
    Products IS NOT NULL;

select * from dim_product;

-- dim_Order table

CREATE TABLE dim_order (
    Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Order_Status NVARCHAR(50),
    Shipping_Method NVARCHAR(50),
    Payment_Method NVARCHAR(50)
);

INSERT INTO dim_order (Order_Status, Shipping_Method, Payment_Method)
SELECT DISTINCT 
    Order_Status,
    Shipping_Method,
    Payment_Method
FROM dbo.new_retail_data
WHERE 
    Order_Status IS NOT NULL AND 
    Shipping_Method IS NOT NULL AND 
    Payment_Method IS NOT NULL;

select * from dim_order;


-- dim_date table
CREATE TABLE dim_date (
    Date_ID INT IDENTITY(1,1) PRIMARY KEY,
    Full_Date DATE,
    Day INT,
    Month INT,
    Month_Name NVARCHAR(20),
    Year INT,
    DayOfWeek NVARCHAR(20),
    Quarter INT,
    Time NVARCHAR(10)
);

INSERT INTO dim_date (Full_Date, Day, Month, Month_Name, Year, DayOfWeek, Quarter, Time)
SELECT DISTINCT 
    Date AS Full_Date,
    DATEPART(DAY, Date) AS Day,
    DATEPART(MONTH, Date) AS Month,
    DATENAME(MONTH, Date) AS Month_Name,
    DATEPART(YEAR, Date) AS Year,
    DATENAME(WEEKDAY, Date) AS DayOfWeek,
    DATEPART(QUARTER, Date) AS Quarter,
    CONVERT(VARCHAR(8), TimeN, 108) AS Time
FROM dbo.new_retail_data
WHERE Date IS NOT NULL AND TimeN IS NOT NULL;

select * from dim_date where Full_Date = '2024-02-22';


-- dim_feedback table

CREATE TABLE dim_feedback (
    Feedback_ID INT IDENTITY(1,1) PRIMARY KEY,
    Feedback_Text VARCHAR(50),
    Sentiment VARCHAR(20),
    Feedback_Score INT
);

INSERT INTO dim_feedback (Feedback_Text, Sentiment, Feedback_Score)
VALUES 
('Excellent', 'Positive', 5),
('Good', 'Positive', 4),
('Average', 'Neutral', 3),
('Bad', 'Negative', 2),
('not-provided', 'Unknown', 0);

select * from dim_feedback;



-- creating Fact Table

CREATE TABLE fact_sales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    Transaction_ID VARCHAR(50),
    Customer_ID INT FOREIGN KEY REFERENCES dim_customer(Customer_ID),
    Product_ID INT FOREIGN KEY REFERENCES dim_product(Product_ID),
    Order_ID INT FOREIGN KEY REFERENCES dim_order(Order_ID),
    Date_ID INT FOREIGN KEY REFERENCES dim_date(Date_ID),
    Feedback_ID INT FOREIGN KEY REFERENCES dim_feedback(Feedback_ID),
    Total_Purchases INT,
    Amount FLOAT,
    Total_Amount FLOAT,
    Ratings FLOAT
);

-- Inserting data into Fact Table

-- Create a temporary staging table with RowNum
SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum,
    *
INTO #StagingRetailData
FROM dbo.new_retail_data;

-- Insert only 100 rows from the staging table
INSERT INTO fact_sales (
    Transaction_ID, Customer_ID, Product_ID, Order_ID, Date_ID, Feedback_ID, Total_Purchases, Amount, Total_Amount, Ratings
)
SELECT
    s.Transaction_ID, dc.Customer_ID, dp.Product_ID, do.Order_ID, dd.Date_ID, df.Feedback_ID, s.Total_Purchases, s.Amount,
    s.Total_Purchases * s.Amount AS Total_Amount, s.Ratings
FROM #StagingRetailData s
JOIN dim_customer dc 
    ON s.Name = dc.Name AND s.Email = dc.Email
JOIN dim_product dp 
    ON s.Product_Category = dp.Product_Category
   AND s.Product_Brand = dp.Product_Brand
   AND s.Product_Type = dp.Product_Type
   AND s.Products = dp.Products
JOIN dim_order do 
    ON s.Order_Status = do.Order_Status
   AND s.Payment_Method = do.Payment_Method
   AND s.Shipping_Method = do.Shipping_Method
JOIN dim_date dd 
    ON s.Date = dd.Full_Date 
   AND CONVERT(VARCHAR(8), s.TimeN, 108) = dd.Time
JOIN dim_feedback df 
    ON s.Feedback = df.Feedback_Text
WHERE s.RowNum BETWEEN 1 AND 100;



-- Inserting the remaining data

-- Step 1: Set batch variables
DECLARE @BatchSize INT = 1000;
DECLARE @StartRow INT = 101;
DECLARE @RowCount INT = 1;

-- Step 2: Loop for inserting remaining data
WHILE @RowCount > 0
BEGIN
    INSERT INTO fact_sales (
        Transaction_ID, Customer_ID, Product_ID, Order_ID, Date_ID, Feedback_ID, Total_Purchases, Amount, Total_Amount, Ratings
    )
    SELECT
        s.Transaction_ID, dc.Customer_ID, dp.Product_ID, do.Order_ID, dd.Date_ID, df.Feedback_ID, s.Total_Purchases, s.Amount,
        s.Total_Purchases * s.Amount AS Total_Amount, s.Ratings
    FROM #StagingRetailData s
    JOIN dim_customer dc 
        ON s.Name = dc.Name AND s.Email = dc.Email
    JOIN dim_product dp 
        ON s.Product_Category = dp.Product_Category
           AND s.Product_Brand = dp.Product_Brand
           AND s.Product_Type = dp.Product_Type
           AND s.Products = dp.Products
    JOIN dim_order do 
        ON s.Order_Status = do.Order_Status
           AND s.Payment_Method = do.Payment_Method
           AND s.Shipping_Method = do.Shipping_Method
    JOIN dim_date dd 
        ON s.Date = dd.Full_Date 
           AND CONVERT(VARCHAR(8), s.TimeN, 108) = dd.Time
    JOIN dim_feedback df 
        ON s.Feedback = df.Feedback_Text
    WHERE s.RowNum BETWEEN @StartRow AND (@StartRow + @BatchSize - 1);

    SET @RowCount = @@ROWCOUNT;
    SET @StartRow = @StartRow + @BatchSize;
END;


-- Clean up the staging table 
DROP TABLE IF EXISTS #StagingRetailData;

-- Issues came after creating fact table,

--checkin if there is any duplicate row
SELECT Transaction_ID, COUNT(*) AS cnt
FROM fact_sales
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

-- looking for number of duplicate rows
SELECT COUNT(*) - COUNT(DISTINCT Transaction_ID) AS DuplicateCount
FROM fact_sales;

-- Deleting duplicate rows
WITH RankedFacts AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Transaction_ID ORDER BY (SELECT NULL)) AS rn
    FROM fact_sales
)
DELETE FROM RankedFacts
WHERE rn > 1;

-- checking for other faults

--Check for NULLs in Foreign Keys
SELECT *
FROM fact_sales
WHERE Customer_ID IS NULL 
   OR Product_ID IS NULL 
   OR Order_ID IS NULL 
   OR Date_ID IS NULL 
   OR Feedback_ID IS NULL;


-- Check for NULLs in Key Metrics
SELECT *
FROM fact_sales
WHERE Total_Purchases IS NULL 
   OR Amount IS NULL 
   OR Total_Amount IS NULL 
   OR Ratings IS NULL;

-- Check if Total_Amount is calculated correctly
SELECT *
FROM fact_sales
WHERE Total_Amount <> (Amount * Total_Purchases);

















