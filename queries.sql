use coffee_shop

#calculate total sales for respective month  --- Practice Well
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty * unit_price)) AS currentSales,
    (ROUND(SUM(transaction_qty * unit_price)) - 
        LAG(ROUND(SUM(transaction_qty * unit_price))) 
        OVER (ORDER BY MONTH(transaction_date))) /
        LAG(ROUND(SUM(transaction_qty * unit_price))) 
        OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (3, 4)  -- only for the months of March and Apriltransaction_id
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    
    --- total orders in respective months
    select count(transaction_id) as total_orders
    from coffee_shop_sales
    where month(transaction_date)=3 
    
    --- change in orders for corrosponding months
    
    SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

       
--Total quantity sold
       
select sum(transaction_qty) as total_quantity_sold
from coffee_shop_sales
where month(transaction_date)=4

--- percentage change in qunatity

    select count(transaction_id) as total_orders
    from coffee_shop_sales
    where month(transaction_date)=3 
    
--- change in orders for corrosponding months
    
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(sum(transaction_qty)) AS total_quantity,
    (COUNT(transaction_qty) - LAG(COUNT(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    
-- calender heat mp
select concat(round(sum(unit_price*transaction_qty)/1000),'K') as Total_Sales,
   sum(transaction_qty) as Total_Qty_Sold,
count(transaction_id) as Total_Orders
from coffee_shop_sales
where transaction_date='2023-05-18'

--- Weekday and Weekend sales

SELECT
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    concat(Round(SUM(transaction_qty * unit_price)/1000),'K') AS total_sales
FROM 
    coffee_shop_sales
where 
    month(transaction_date)=2
GROUP BY 
    day_type
ORDER BY 
    day_type;
    
--- sales by store location

select
       store_location,
       concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by store_location
order by total_sales desc


-- daily sales and average of month
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;


-- sales by product_category
 select product_category,round(sum(unit_price*transaction_qty)) as total_sales
 from coffee_shop_sales
 where month(transaction_date)=5
 group by product_category
 order by total_sales desc
 Limit 10   -- if required to get top 10 products
 
-- sales by day and hour
 
 SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

-- To get Sales from Monday to Sunday

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;


-- sales for all hours of month

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
END;

    
