
--select * from sales.customers
select first_name,email from sales.customers

select first_name+' '+last_name from sales.customers --single char - single quotes

select first_name+' '+last_name as 'f'from sales.customers --or
select first_name+' '+last_name 'f'from sales.customers

select email from sales.customers s

/*
sorting - order by
*/

select first_name,last_name from sales.customers order by first_name
select first_name,last_name from sales.customers order by first_name desc,last_name asc 


--filtering : where

select * from sales.customers where zip_code = '12010';
select * from sales.customers where zip_code != '12010'

select * from production.stocks where quantity >= 20 order by quantity 

select * from production.stocks where quantity >= 20 and
quantity < 25 and product_id=40 order by quantity desc

select state,first_name from sales.customers where state = 'CA' or state = 'NY' 
select state,first_name from sales.customers where state in ('CA','NY' )
select state,first_name from sales.customers where state not in ('CA','NY' )
select state,first_name from sales.customers where state != 'CA' and state != 'NY' 
select state,city,first_name from sales.customers where (state != 'CA' and state != 'NY') or city ='Apple valley'

select distinct state,first_name from sales.customers 
select distinct state from sales.customers 

select * from sales.customers where phone is null
select * from sales.customers where phone is not null

select * from sales.customers where first_name like 'Ar%' 
select * from sales.customers where first_name like 'ar%'
select * from sales.customers where first_name like 'A%d'
select * from sales.customers where first_name like 'A____d' -- 4 letter between a and d , position searchin
select * from sales.customers where first_name like 'A___d' --3 underscore
select * from sales.customers where first_name like 'A___n%'



select * from production.products where model_year 
between 2016 and 2018
select * from production.products where model_year 
not between 2016 and 2018


--Aggregation nd filtering

select * from production.products
select count(*) from production.products --count of rows
select count(model_year),count(distinct model_year) from production.products

select count(phone),count(*) from sale.customers --not count null values of column phone
select max(list_price) 'max',min(list_price) 'min',avg(list_price)'avg' from production.products 
where model_year = 2019

select count(phone),count(*) from sale.customers --not count null values of column phone
select model_year,max(list_price) 'max',min(list_price) 'min',avg(list_price)'avg' from production.products 
group by model_year

select model_year,count(model_year)  'no of products' ,max(list_price)from production.products 
group by model_year having count(model_year) >50

--where avg(list_price) cant be used
--with grpby we cant use categorical data selectin
--having - only used with grp functions


select product_name,model_year,avg(list_price) over (partition by model_year) as 'avgprice',list_price,
list_price-avg(list_price) over (partition by model_year) as 'diff'  from production.products where model_year=2017

select top(5) * from  production.products 

select top 5 percent * from  production.products 

select * from (select product_name,model_year,category_id,list_price from production.products where model_year=2016) as "subtable"

select subtable.* from (select product_name,model_year,category_id,list_price from production.products where model_year=2016) 
as "subtable" where subtable.category_id=3


--functions
select FORMAT(45355565656,'###-###-####') f
select list_price,FORMAT(list_price,N'C',N'en-In') list from production.products

select GETDATE()
select format(GETDATE(),'yyyy-MMM-dd')

--right,upper,lower
select upper(category_name),left(category_name,5),len(category_name) from  production.categories


update production.categories set category_name = '     '+category_name+'    '

select category_name,trim(category_name) from  production.categories

select category_name,PATINDEX('%BI%',category_name) from  production.categories --position

select category_name,replace(category_name,'bikes','mbikes'),reverse(category_name) from  production.categories 

select list_price, str(list_price) from  production.products 

select SUBSTRING(product_name,3,7) from  production.products 

select CURRENT_TIMESTAMP,GETDATE()

select year(GETDATE()),month(GETDATE()),day(GETDATE()) --or do format()

select dateadd(year,2,GETDATE()) --from getdate

select dateadd(year,-2,GETDATE())

select dateadd(month,-2,GETDATE())

select dateadd(week,-2,GETDATE()) --hr,mt,sec,milli sec

select datediff(year,-2,GETDATE())



select * from dbo.emp

select hiredate,datediff(year,hiredate,format(GETDATE(),'yyyy-mm-dd')) as 'year diff' from emp

select ISDATE('uyiyi')
select ISDATE('2009-09-08'),SYSDATETIME(),GETDATE() --getdate serverside time , sysdatetime -client side date



select * from emp

select sal,comm,round(sal,0) from emp

select list_price, round(list_price,0) from  production.products -- round 1 - 1 decimel point

select list_price, ceiling(list_price) 'ceil',floor(list_price) 'flr',abs(-67),abs(789) from  production.products

select rand()*10 --0 to 9



select * from emp

select iif(comm>0.00,'commission received','no commission') as res from emp

select sal, iif(comm>0.00,sal+comm,sal) as res from emp

select isnull(comm,0.00) from emp

select user_name(),SYSTEM_USER

--isdigit,isnumeric

select ename,
case 
when sal>=8000 and sal<=10000 then 'Director'
when sal>=8000 and sal<=10000 then 'Snr consultant'
else 'Director'
end as Designation
from emp



select * from production.products order by list_price desc

--dense rank is window function that assign rank to each row within a partiton of result set

select product_id,product_name,list_price, rank() over (order by list_price desc),
dense_rank() over (order by list_price desc)
from production.products
-- same value same rank(3,3,3,3), but the succeding rank after that is ranked 7
--dense rank, after (3,3,3,3) 4 comes





select product_id,sum(list_price) from sales.order_items group by product_id
select product_id,sum(list_price) from sales.order_items group by cube(product_id,item_id)
--cube : gives summation both level or prodcut_id level or item_id

select sum(list_price) from

select * from sales.order_items



select product_id,item_id,sum(list_price) sales from sales.order_items group by product_id, rollup (item_id)




--joins - 2 or more tables based on common col - inner,outer,cross

select * from production.products
select * from production.categories

select p.product_name,p.list_price,p.category_id,c.category_name from production.products p inner join production.categories c
on c.category_id = p.category_id where list_price>5000 order by p.product_name

--table with less num of rows first - c .col = p.col


--left outer join

--product not ordered
select product_name,order_id from production.products p left join sales.order_items c
on c.product_id = p.product_id where c.order_id is null


select product_name,s.order_id,item_id,order_date from production.products p left join sales.order_items c
on c.product_id = p.product_id left join sales.orders s on s.order_id = c.order_id where s.order_id is null

select ename,dname from emp e 
right join dept d on e.deptno =d.deptno

--union
select e.*,d.* from dept d full join emp e 
on e.deptno =d.deptno

select e.*,d.* from dept d cross join emp e --cartesian
order by ename

--self
select c1.city,c1.first_name+''+c1.last_name cus1,
c2.first_name+''+c2.last_name cus2 from sales.customers c1
inner join sales.customers c2
on c1.customer_id> c2.customer_id and c1.city = c2.city
order by c1.city ,c1.first_name


--manager fr employee
select *  from emp
select e.ename 'emp',m.ename 'manager' from emp e 
inner join emp m on m.empno = e.mgr
order by m.ename



--subquery -dont need the data from table to display bt need that data inorder to specify some conditions
select * from sales.orders where customer_id in -- = is 1 value or use any/all
(select customer_id from sales.customers where city = 'New York')

select * from  emp 
select * from  salgrade

select deptno from emp where sal>(select max(losal) from  salgrade)

select dname from dept where deptno in 
(select deptno from emp where sal>
(select max(losal) from  salgrade)
)



