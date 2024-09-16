create database  if not exists Retails;
use retails;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
select * from retail_sales;

/*No_of_records*/
select count(*)Total_records from retail_sales;
/*Customer Count*/
select count(distinct customer_id)Cus_count from retail_sales;
/*Category Count*/
select category,count(distinct category)Ca_count from retail_sales
group by category;
/*Data Cleaning*/
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
delete FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    


alter table retail_sales add column Month_name varchar(30) ;

update retail_sales
set month_name = monthname(sale_date);
alter table retail_sales add column year int ;
update retail_sales
set year = year(sale_date);

alter table retail_sales add column shift varchar(10) ;
update retail_sales
set shift =(case when sale_time between "00:00:00" and "12:00:00" then "Morning"
when sale_time between "12:01:00" and "17:00:00" then "Afternoon"
else "Evening"
end);
    
/*1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:*/
select * from retail_sales
where sale_date = "2022-11-05";
/*2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:*/
select transaction_id from retail_sales
where category ="Clothing" and quantity >= 4 and year = 2022 and month_name ="November";

select transaction_id from retail_sales
where category ="Clothing" and quantity >= 4 and year(sale_date) = 2022 and monthname(sale_date) ="November";

/*3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:*/
select category,sum(total_sale)T_sales,count(*)T_orders from retail_sales
group by category
order by T_orders desc;
/*4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:*/
select round(avg(age),0)Avg_age from retail_sales
where category ="Beauty";
/*5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:*/
select * from retail_sales
where total_sale > 1000;
/*6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:*/ 
select gender , category,count(*)Cnt from retail_sales
group by gender,category;
/*7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:*/
select year, month_name from
(select year,Month_name,round(avg(total_sale),2)Avg_sales,
rank() over(partition by year order by avg(total_sale)) as rk from retail_sales
group by 1,2)sub
where rk = 1;
/*8. **Write a SQL query to find the top 5 customers based on the highest total sales **:*/
select customer_id,sum(total_sale)T_sales from retail_sales
group by customer_id
order by T_sales desc
limit 5;
/*9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:*/
select category,count(distinct customer_id)Cnt from retail_sales 
group by category
order by cnt desc;
/*10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:*/ 

select shift,count(*)T_orders from retail_sales
group by shift;
