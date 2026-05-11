CREATE TABLE customers_1(customer_id INT, customer_name VARCHAR(50), gender VARCHAR(20), city VARCHAR(100));
CREATE TABLE products(product_id INT, product_name VARCHAR(50),category VARCHAR(20), price INT
);
CREATE TABLE orders(order_id INT, customer_id INT, product_id INT, order_date DATE, order_quantity INT
);
CREATE TABLE payments(payment_id INT, order_id INT, payment_method VARCHAR(20), payment_amount INT, payment_status VARCHAR(20)
);
COPY customers_1 FROM 'C:\Users\ayush\Downloads\customers_1.csv' WITH (FORMAT csv, HEADER true);
COPY orders FROM 'C:\Users\ayush\Downloads\orders.csv' WITH (FORMAT csv, HEADER true);
COPY payments FROM 'C:\Users\ayush\Downloads\payments.csv' WITH (FORMAT csv, HEADER true);
COPY products FROM 'C:\Users\ayush\Downloads\products.csv' WITH (FORMAT csv, HEADER true);
SELECT * FROM customers_1
SELECT * FROM payments
SELECT * FROM products
SELECT * FROM orders

-- DATA CLEANING
-- remove extra spaces from customer names

select trim(customer_name) AS clean_name
from customers_1

-- find number of missing cities

select count (*)
from customers_1
where city is null;

-- ANALYSIS
-- 1. show all orders placed in january 2024

select * from orders
where order_date between '2024-01-01' and '2024-01-31'

--2. count total number of customers
select count (*) as total_customers from customers_1

-- JOINS
--3. show order details with customer names
select o.order_id, c.customer_name, o.order_date
from orders o
join customers_1 c
on o.customer_id = c.customer_id;

-- show products purchased by each customers


SELECT c.customer_name, p.product_name, o.order_quantity
FROM customers_1 c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id;

-- BUSINESS KPIs
--4.total sales amount

SELECT SUM(payment_amount) as total_sales
from payments
where payment_status = 'Success';

--5. top 5 selling products

SELECT p.product_name, sum(o.order_quantity) as total_sold
from orders o
join products p on o.product_id = p.product_id
group by p.product_name
order by total_sold desc
limit 5;

-- revenue by category
select p.category, sum(py.payment_amount) as total_revenue
from payments py
join orders o on py.order_id = o.order_id
join products p on o.product_id = p.product_id
group by p.category;






-- city wise customer count
select city, count(*) as total_customers
from customers_1
group by city;

-- top 5 customers who bought the most

select c.customer_name, sum(o.order_quantity)
as qty
from orders o
join customers_1 c on o.customer_id = c.customer_id
group by c.customer_name
order by qty desc limit 5;

select * from customers_1;

-- uses of window functions
--rank
select customer_name, gender, city,
	rank() over(partition by gender order by customer_id desc) as rankk
	from customers_1;

--dense rank
select customer_name, gender, city,
	dense_rank() over(partition by gender order by customer_id desc) as rankk
	from customers_1;

-- row number
select customer_name, gender, city,
	row_number() over(partition by gender order by customer_id desc) as row_num
	from customers_1;

