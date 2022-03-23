
-- This sample database has been downloaded from https://www.mysqltutorial.org/mysql-sample-database.aspx
USE classicmodels;
select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

-- Total amount by status 
select Status, Sum(amount)
from orders as o 
inner join payments as p
on o.customerNumber = p.customerNumber
group by Status;

select productcode,msrp from products
where productcode in (select productcode from orderdetails -- In here join is not used
where priceeach <100);

#stored procedures (SP)
 delimiter &&
 create procedure below_100()
 begin
select productcode,msrp from products
where productcode in (select productcode from orderdetails
where priceeach <100);
end &&
delimiter ;  -- keep a space

call below_100();-- writing the "call" simple allows you to repeat e.g. the the baove long codes in a simple way.


# SP using IN 
delimiter //
create procedure sp_sortbyamount(in var int)
begin
select customerNumber,amount from payments
order by amount desc limit var; -- by top n amount
end //
delimiter ;

call sp_sortbyamount(5); -- top three amount


-- One good way to update manually
delimiter //
create procedure update_priceEach2 (IN temp int, IN PE int)
begin
update orderdetails set
priceEach = PE where orderNumber = temp;
end; //
call update_priceEach2 (10100, 96);


-- The below gives same results as "select count(distinct(orderNumber)) from orderdetails where productCode = 'S18_1749';"
delimiter //
create procedure countEmp (out total_emp int)
begin
select count(orderNumber) into total_emp from orderdetails
where productCode = 'S18_1749';
end //
delimiter ;

call countEmp(@emp);
select @emp as PC;



# Views in SQL -- they dont store data but for visual pupose only

select * from customers;

create view cust_details
as
select customerName, phone, city
from customers;  -- view created
select * from cust_details;


select * from productlines;

create view product_description
as
select productName, quantityinstock, msrp, textdescription
from products as p inner join productlines as pl
on p.productline = pl.productline;
select * from product_description;


-- using join find qhich is the easiets 
create view try_view
as
select customerNumber, o.orderNumber, productCode 
from orders as o inner join orderdetails as od
on o.orderNumber = od.orderNumber;

-- Auto indent = ctrl + B
SELECT 
    *
FROM
    try_view
WHERE
    customerNumber = 103;



# Partition by and inner join

select * from payments;

create view multi_fuctions_in_1
as
select o.customerNumber, status, sum(amount) over (partition by status) as otal_amount
from orders as o
inner join payments as p
on o.customerNumber = p.customerNumber;

select * from multi_fuctions_in_1;


-- Row_number can be helpful finding duplicates


select Status, max(amount), o.customerNumber 
from orders as o 
inner join payments as p
on o.customerNumber = p.customerNumber
group by status;


select Status, o.customerNumber, amount
from orders as o 
inner join payments as p
on o.customerNumber = p.customerNumber
group by status;


use classicmodels;

-- List of OfficeCode (Dept) with more than 2 employees.
select officecode, Count(officeCode) from employees
group by officecode
having Count(officeCode) >2;


-- Find all the officecode except OfficeCode 1
select * from employees
where officeCode <> 1; 

select * from payments;

-- transaction between two dates
select * from payments
where paymentDate > '2003-06-09' and paymentDate < '2004-06-09';

-- print alternate rows, 
select * from payments where customerNumber % 2 = 1; -- In here, finding odd customerNumbers and "% 2 = 1" means 1 would be reminder if I was do divide by 2.

-- finding Duplicates
select customerNumber, customerName,country, count(*) from customers
group by customerNumber, customerName,country
having count(customerNumber) >1 and count(customerName)>1 and count(country)>1;

-- Find LastName having two Ts
select * from employees
where length(lastName) - length(replace(Upper(lastName),'T','')) = 2; -- making the names all upper and repalce T with blank and after the minus it should equal to 2


-- Extract 4 characters starting from 2nd position.
select substr(lastname,2,4) from employees; 

-- number of employees in each officeCode
 select officeCode, count(*) from employees
 group by officeCode;

-- list of employee share the same officecode
select distinct e.employeeNumber, e.lastName, e.officeCode 
from employees as e, employees as e1
where e.officeCode = e1.officeCode and e.employeeNumber != e1.employeeNumber;
 
 


