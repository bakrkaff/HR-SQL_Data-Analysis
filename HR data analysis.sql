--How many employees got hired in 2011.
-- Employees who got hired after January 2010 and are serniors.
-- Which month has the highest hiring in 2009 .
-- Highest paid employee.
-- How many sales people hit their Quota this year?
-- which product got ordered the most in 2014?
-- which product generated the most revenue in 2014?
-- Calculate the revenue for years 2011 - 2014? 



-- Employees who got hired after January 2010 and are serniors.
select JobTitle, BirthDate, HireDate,
GETDATE() AS Today,
DATEDIFF(YY,BirthDate,GETDATE()) AS Age
from HumanResources.Employee
where HireDate > '2010-01-30'
AND DATEDIFF(YY,BirthDate,GETDATE()) >= '60';


--How many employees got hired in 2011.
Select count(*), year(HireDate)
from HumanResources.Employee
where year(HireDate) = '2011'
group by year(HireDate);


-- Which year has the highest hiring.
with HighiestYear as (
Select count(BusinessEntityID) as Quantity, year(HireDate) as HiringYear
from HumanResources.Employee
group by year(HireDate)
)

select Quantity, HiringYear
from HighiestYear
where Quantity = (SELECT max(Quantity) from HighiestYear);

-- Which month has the highest hiring in 2009 .
select COUNT(BusinessEntityID) as Count, YEAR(HireDate) as Year, MONTH(HireDate) as Month
from HumanResources.Employee
where YEAR(HireDate) = '2009'
group by YEAR(HireDate), MONTH(HireDate);

-- Highest paid employee.
select FirstName, LastName, Rate, JobTitle
from Person.Person p
join HumanResources.EmployeePayHistory h on p.BusinessEntityID = h.BusinessEntityID
join HumanResources.Employee e on p.BusinessEntityID = e.BusinessEntityID
where Rate = (select max(Rate) from HumanResources.EmployeePayHistory);

-- How many sales people hit their Quota this year?
select FirstName, LastName, SalesYTD, SalesQuota
from Person.Person p
join Sales.SalesPerson s on p.BusinessEntityID = s.BusinessEntityID
where s.SalesYTD >= SalesQuota
order by s.SalesYTD DESC;

-- which product got ordered the most in 2014? -- Water Bottle - 30 oz.
with MaxOrder as (
Select distinct d.ProductID, p.Name, sum(OrderQty) as Quantity
from Sales.SalesOrderDetail d
join Production.Product p on d.ProductID = p.ProductID
join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
where year(OrderDate) = '2014'
group by d.ProductID, p.Name
)

Select ProductID, Name, Quantity
from MaxOrder 
where Quantity = (select max(Quantity) from MaxOrder);

-- which product generated the most revenue in 2014? -- Mountain-200 Black, 38 generated 1045214.639668
with MaxOrder as (
Select distinct d.ProductID, p.Name, sum(OrderQty) as Quantity, sum(LineTotal) as Revenue
from Sales.SalesOrderDetail d
join Production.Product p on d.ProductID = p.ProductID
join Sales.SalesOrderHeader h on d.SalesOrderID = h.SalesOrderID
where year(OrderDate) = '2014'
group by d.ProductID, p.Name

)
Select ProductID, Name, Quantity, Revenue
from MaxOrder
where Revenue = (select max(Revenue) from MaxOrder);

-- Calculate the revenue for years 2011 - 2014?
select year(OrderDate), sum(SubTotal) as Revenue
from Sales.SalesOrderHeader
group by year(OrderDate)
order by year(OrderDate);