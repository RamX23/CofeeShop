create database Coffee_shop
use Coffee_shop
select * from coffee_shop_sales

describe coffee_shop_sales

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');


ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

alter table coffee_shop_sales
modify column transaction_time time

alter table coffee_shop_sales change column ï»¿transaction_id transaction_id int 