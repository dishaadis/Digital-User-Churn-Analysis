create table if not exists Customers(
	CustomerID numeric primary key not null,
	FirstName varchar(100),
	LastName varchar(100),
	CustomerEmail varchar(100),
	CustomerPhone varchar(100),
	CustomerAddress varchar(100),
	CustomerCity varchar(100),
	CustomerState varchar(100),
	CustomerZip numeric
);

create table if not exists Orders(
	OrderID numeric primary key not null,
	Date date,
	CustomerID numeric,
	ProdNumber varchar(100),
	Quantity numeric
);

create table if not exists ProductCategory(
	CategoryID numeric primary key not null,
	CategoryName varchar(100),
	CategoryAbbreviation varchar(100)
);

create table if not exists Products(
	ProdNumber varchar(100) primary key not null ,
	ProdName varchar(100),
	Category numeric,
	Price numeric
);

create table if not exists Master as (
	select 
		o.Date as order_date,
		pc.CategoryName as category_name,
		p.ProdName as product_name,
		p.Price as product_price,
		o.Quantity as order_qty,
		(o.Quantity * p.Price) as total_sales,
		c.CustomerEmail as cust_email,
		c.CustomerCity as cust_city
	from 
		Orders as o
	left join 
		Customers as c on o.CustomerID = c.CustomerID
	left join
		Products as p on o.ProdNumber = p.ProdNumber
	left join 
		ProductCategory as pc on pc.CategoryID = p.Category
	order by 1,5
);

--Total Overall Sales
select 
	sum(total_sales) as sum_of_total_sales,
	sum(order_qty) as sum_of_total_quantity,
	count(order_date) as total_order,
	count(distinct cust_email) as total_customer,
	count(distinct cust_city) as total_city
from 
	master;
	
--Total Sales 2020 and 2021	
select 
	extract(year from order_date) as year,
	sum(total_sales) as sum_of_total_sales
from 
	master
group by 1
order by 1;

--Total Quantity 2020 and 2021
select 
	extract(year from order_date) as year,
	sum(order_qty) as sum_of_total_quantity
from 
	master
group by 1
order by 1;

--Total Order 2020 and 2021
select 
	extract(year from order_date) as year,
	count(order_date) as total_order
from 
	master
group by 1
order by 1;

--Total Customer Order
select cust_email, count(cust_email)
from master
group by 1
order by 2;

--Total Sales by Month
select 
	extract(year from order_date) as year,
	extract(month from order_date) as month,
	sum (total_sales) as sum_of_total_sales
from 
	master
group by 1,2
order by 1,2;

--Total Quantity by Month
select 
	extract(year from order_date) as year,
	extract(month from order_date) as month,
	sum (order_qty) as sum_of_total_Quantity
from 
	master
group by 1,2
order by 1,2;

--Total Sales by Category Product
select 
	category_name,
	sum (total_sales) as sum_of_total_sales
from 
	master
group by 1
order by 2 desc;

--Total Quantity by Category Product
select 
	category_name,
	sum (order_qty) as sum_of_total_Quantity
from 
	master
group by 1
order by 2 desc;

--Total Sales by City
select 
	cust_city,
	sum (total_sales) as sum_of_total_sales
from 
	master
group by 1
order by 2 desc;

--Total Quantity by city
select 
	cust_city,
	sum (order_qty) as sum_of_total_quantity
from 
	master
group by 1
order by 2 desc;

--Top 5 Product Name with The Highest Sales
select category_name, product_name, sum(total_sales) as sum_of_total_sales
from master
group by 1,2
order by 3 desc;

--Top 5 Product Name with The Highest Quantity
select category_name,product_name, sum (order_qty) as sum_of_total_quantity
from master
group by 1,2
order by 3 desc;

--Top 5 most ordered products	
select category_name,product_name, count(order_date) as total_order_product
from master
group by 1,2
order by 3 desc;