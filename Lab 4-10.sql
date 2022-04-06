--
--Modul 4
--

--
--No.1
--Display Maximum Price (obtained from the maximum price of all treatment), 
--Minimum Price (obtained from minimum price of all treatment), 
--and Average Price (obtained by rounding the average value of Price in 2 decimal format).
--(max, min, cast, round, avg)
--

select
max(Price) as [Maximum Price], min(Price) as [Minimimum Price],  
CAST(ROUND(AVG(Price), 0) AS DECIMAL (20, 2)) as [Average Price] 
from MsTreatment

--cast (round (avg(namatabel.kolom)) as numeric (8,2)

--
--No. 2
--Display StaffPosition, Gender (obtained from first character of staff’s gender), 
--and Average Salary (obtained by adding ‘Rp.’ in front of the average of StaffSalary in 2 decimal format).
--(left, cast, avg, group by)
--

SELECT StaffPosition AS [Staff Postion],
LEFT(StaffGender, 1) AS [Staff Gender],
CONCAT ('Rp. ', CAST(AVG(StaffSalary) AS DECIMAL (20, 2))) AS [Average Salary]
FROM MsStaff
GROUP BY StaffPosition, StaffGender

--
--No. 3
--Display TransactionDate (obtained from TransactionDate in ‘Mon dd,yyyy’ format), 
--and Total Transaction per Day (obtained from the total number of transaction).
--(convert, count, group by)
--

SELECT
convert (char, TransactionDate, 107) AS [Transaction Date],
COUNT (TransactionDate) AS [Total Transaction per Day]
FROM HeaderSalonServices
GROUP BY TransactionDate

--
--No. 4
--Display CustomerGender (obtained from customer’s gender in uppercase format), 
--and Total Transaction (obtained from the total number of transaction).
--(upper, count, group by)
--

SELECT
UPPER(MsCustomer.CustomerGender) AS [Customer Gender],
COUNT(HeaderSalonServices.TransactionId) AS [Total Transaction]
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
GROUP BY CustomerGender

--
--No. 5
--Display TreatmentTypeName, and Total Transaction (obtained from the total number of transaction). 
--Then sort the data in descending format based on the total of transaction.
--(count, group by, order by)
--

SELECT
MsTreatmentType.TreatmentTypeName AS [Treatment Type Name],
COUNT(DetailSalonServices.TransactionId) AS [Total Transaction]
FROM MsTreatmentType JOIN MsTreatment
ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
JOIN DetailSalonServices 
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
GROUP BY TreatmentTypeName
ORDER BY [Total Transaction] DESC;


--
--No. 6
--Display Date (obtained from TransactionDate in ‘dd mon yyyy’ format), 
--Revenue per Day (obtained by adding ‘Rp. ’ in front of the total of price) 
--for every transaction which Revenue Per Day is between 1000000 and 5000000.
--(convert, cast, sum, group by, having)
--


--Cara 1 Pakai Join
SELECT
CONVERT(CHAR, HeaderSalonServices.TransactionDate, 113) AS [Date],
CONCAT ('Rp. ', CAST(SUM(MsTreatment.Price) AS VARCHAR)) AS [Revenue per Day]
FROM DetailSalonServices JOIN HeaderSalonServices
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsTreatment ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
GROUP BY TransactionDate
HAVING SUM(MsTreatment.Price) BETWEEN 1000000 AND 5000000;


--Cara 2 Pakai WHERE AND
SELECT
CONVERT(CHAR, HeaderSalonServices.TransactionDate, 113) AS [Date],
CONCAT('Rp. ', CAST(SUM(MsTreatment.Price) AS VARCHAR)) AS [Revenue per Day]
FROM HeaderSalonServices, DetailSalonServices, MsTreatment
WHERE HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
GROUP BY TransactionDate 
HAVING SUM(MsTreatment.Price) BETWEEN 1000000 AND 5000000;

--
--No. 7
--Display ID (obtained by replacing ‘TT0’ in TreatmentTypeID with ‘Treatment Type’), 
--TreatmentTypeName, and Total Treatment per Type (obtained from the total number of treatment 
--and ended with ‘ Treatment ’) for treatment type that consists of more than 5 treatments. 
--Then sort the data in descending format based on Total Treatment per Type.
--(replace, cast, count, group by, having, order by)
--

--REPLACE(string, substring yang akan diganti, substring penggati)

SELECT
REPLACE(MsTreatment.TreatmentTypeId, 'TT0', 'Treatment Type ') AS [ID],
CONCAT (COUNT(MsTreatment.TreatmentTypeId), ' Treatment') AS [Total Treatment per Day]
FROM MsTreatment JOIN MsTreatmentType
ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
GROUP BY MsTreatment.TreatmentTypeId, TreatmentTypeName
HAVING COUNT(MsTreatment.TreatmentTypeId) > 5
ORDER BY [Total Treatment per Day] DESC;

--
--No. 8
--Display StaffName (obtained from first character of staff’s name until character before space), 
--TransactionID, and Total Treatment per Transaction (obtained from the total number of treatment). 
--(left, charindex, count, group by)
--
--CHARINDEX(substring, string, start)
--

SELECT      
LEFT(MsStaff.StaffName, CHARINDEX(' ', MsStaff.StaffName)) AS [Staff Name],
HeaderSalonServices.TransactionId,
COUNT (DetailSalonServices.TreatmentId) AS [Total Treatment per Transaction]
FROM MsStaff JOIN HeaderSalonServices
ON MsStaff.StaffId = HeaderSalonServices.StaffId
JOIN DetailSalonServices
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
GROUP BY MsStaff.StaffName, HeaderSalonServices.TransactionId;

--
--No. 9
--Display TransactionDate, CustomerName, TreatmentName, and Price for every 
--transaction which happened on ‘Thursday’ and handled by Staff whose name contains the word ‘Ryan’. 
--Then order the data based on TransactionDate and CustomerName in ascending format.
--(datename, weekday, like, order by)
--

SELECT	HeaderSalonServices.TransactionDate,MsCustomer.CustomerName,MsTreatment.TreatmentName,MsTreatment.Price
FROM MsCustomer JOIN HeaderSalonServices 
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
JOIN DetailSalonServices 
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsTreatment 
ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE DATENAME (WEEKDAY, TransactionDate) = 'Thursday' 
AND (HeaderSalonServices.StaffId IN (SELECT StaffId FROM MsStaff WHERE StaffName LIKE '%Ryan%')) 
ORDER BY TransactionDate ASC, MsCustomer.CustomerName ASC

--
--No 10
--Display TransactionDate, CustomerName, and TotalPrice 
--(obtained from the total amount of price) for every transaction that happened after 20th day. 
--Then order the data based on TransactionDate in ascending format.
--(sum, day, group by, order by)
--

SELECT HeaderSalonServices.TransactionDate, MsCustomer.CustomerName,
SUM(MsTreatment.Price) AS TotalPrice
FROM MsCustomer, MsTreatment, HeaderSalonServices, DetailSalonServices
WHERE HeaderSalonServices.CustomerId = MsCustomer.CustomerId
AND HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
AND DATENAME(DAY, HeaderSalonServices.TransactionDate) > 20
GROUP BY HeaderSalonServices.TransactionDate, MsCustomer.CustomerName
ORDER BY HeaderSalonServices.TransactionDate ASC


--
--Modul 5
--

--
--No 1
--Display all female staff’s data from MsStaff.
--

SELECT * FROM MsStaff
WHERE StaffGender IN ('Female');

--
--No 2
--Display StaffName, and StaffSalary(obtained by adding ‘Rp.’ In front of StaffSalary) 
--for every staff whose name contains ‘m’ character and has salary more than or equal to 10000000.
--(cast, like)
--

SELECT
StaffName, StaffSalary = 'Rp. ' + CAST(StaffSalary AS VARCHAR)
FROM MsStaff
WHERE StaffName LIKE '%m%' AND StaffSalary >= 1000000;

--
--No 3
--Display TreatmentName, and Price for every treatment which type is 'message / spa' or 'beauty care'.
--(in)
--

SELECT * from dbo.MsTreatmentType
SELECT * from MsTreatment

SELECT TreatmentName, Price
FROM MsTreatment 
JOIN MsTreatmentType ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
WHERE MsTreatmentType.TreatmentTypeName IN ('Message / Spa', 'Beauty Care')

--
--No 4
--Display StaffName, StaffPosition, and TransactionDate 
--(obtained from TransactionDate in Mon dd,yyyy format) 
--for every staff who has salary between 7000000 and 10000000.
--(convert, between)
--

SELECT StaffName, StaffPosition, CONVERT (VARCHAR, TransactionDate, 107) AS [TransactionDate]
FROM HeaderSalonServices JOIN MsStaff
ON HeaderSalonServices.StaffId = MsStaff.StaffId
AND StaffSalary BETWEEN 7000000 AND 10000000;

select * from MsStaff

--
--No 5
--Display Name (obtained by taking the first character of customer’s name until character before space), 
--Gender (obtained from first character of customer’s gender), and PaymentType for every transaction that is paid by ‘Debit’.
--(substring, charindex, left)
--

SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName)) AS [Name],
SUBSTRING(CustomerGender, 1, 1) AS [Gender], PaymentType
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND PaymentType IN ('Debit');

--
--No 6
--Display Initial (obtained from first character of customer’s name and followed 
--by first character of customer’s last name in uppercase format), 
--and Day (obtained from the day when transaction happened ) for every transaction 
--which the day difference with 24th December 2012 is less than 3 days.
--upper, left, substring, charindex, datename, weekday, datediff, day)
--

SELECT CONCAT(UPPER(LEFT(CustomerName, 1)),
UPPER(SUBSTRING(CustomerName, CHARINDEX(' ', CustomerName)+1, 1 ))) AS [Initial],
DATENAME(WEEKDAY, TransactionDate) AS [Day]
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND DATEDIFF(day, TransactionDate, '2012/12/24') < 3

SELECT * FROM MsCustomer

--
--No 7
--Display TransactionDate, and CustomerName (obtained by taking the character after 
--space until the last character in CustomerName) for every customer whose name contains 
--space and did the transaction on Saturday.
--(right, charindex, reverse, like, datename, weekday)
--

SELECT TransactionDate, 
RIGHT(CustomerName, ISNULL(NULLIF(CHARINDEX(' ', REVERSE(CustomerName)) - 1, -1),
LEN(CustomerName))) AS [LastName]
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATENAME(WEEKDAY, TransactionDate) = 'Saturday'
AND CustomerName LIKE '% %';

DECLARE @FullName        VARCHAR(100)
SET @FullName = 'John Doe'

SELECT LEFT(@FullName, CHARINDEX(' ', @FullName) - 1) AS [FirstName],
       RIGHT(@FullName, CHARINDEX(' ', REVERSE(@FullName)) - 1) AS [LastName]


DECLARE @FullName VARCHAR(100)
SET @FullName = 'John Doe'

SELECT LEFT(@FullName, NULLIF(CHARINDEX(' ', @FullName) - 1, -1)) AS [FirstName],
       RIGHT(@FullName, ISNULL(NULLIF(CHARINDEX(' ', REVERSE(@FullName)) - 1, -1),
             LEN(@FullName))) AS [LastName]


--
--No 8
--Display StaffName, CustomerName, CustomerPhone (obtained from customer’s phone by 
--replacing ‘0’ with ‘+62’), and CustomerAddress for every customer whose name contains
--vowel character and handled by staff whose name contains at least 3 words.
--(replace, like)
--

SELECT StaffName, CustomerName,
REPLACE(CustomerPhone, '08', '+62') AS [Customer Phone], CustomerAddress
FROM HeaderSalonServices JOIN  MsCustomer
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
JOIN MsStaff ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE StaffName LIKE '% % %'
AND (CustomerName LIKE '%a%'OR CustomerName LIKE '%i%'
OR CustomerName LIKE '%u%' OR CustomerName LIKE '%e%'
OR CustomerName LIKE '%o%')

--
--No 9
--Display StaffName, TreatmentName, and Term of Transaction (obtained from the day 
--difference between transactionDate and 24th December 2012) for every treatment which 
--name is more than 20 characters or contains more than one word.
--(datediff, day, len, like)
--

SELECT StaffName, TreatmentName,
DATEDIFF(DAY, TransactionDate, '2012/12/24') AS [Term of Transaction]
FROM MsStaff JOIN HeaderSalonServices
ON MsStaff.StaffId = HeaderSalonServices.StaffId
JOIN DetailSalonServices
ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsTreatment
ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
WHERE LEN(TreatmentName) > 20 OR TreatmentName LIKE '% %';

Charindex (' ', TreatmentName) !=0

--
--No 10
--Display TransactionDate, CustomerName, TreatmentName, Discount 
--(obtainedby changing Price data type into int and multiply it by 20%), 
--and PaymentType for every transaction which happened on 22th day.
--(cast, day)
--

SELECT TransactionDate, CustomerName, TreatmentName,
CAST((Price * 20 / 100) AS INT) AS [Discount], PaymentType
FROM MsCustomer, MsTreatment, HeaderSalonServices, DetailSalonServices
WHERE HeaderSalonServices.CustomerId = MsCustomer.CustomerId
AND HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
AND DATEPART(DAY, TransactionDate) = 22;


--
--Modul 6
--

--
--No 1
--Display TreatmentTypeName, TreatmentName, and Price for every treatment which name 
--contains ‘hair’ or start with ‘nail’ word and has price below 100000.
--(join, like)
--

SELECT TreatmentTypeName, TreatmentName, Price
FROM MsTreatment
JOIN MsTreatmentType ON MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
WHERE TreatmentTypeName LIKE '%hair%' OR TreatmentTypeName LIKE 'nail%'
AND Price < 100000

--
--No 2
--Display StaffName and StaffEmail (obtained from the first character of staff’s name 
--in lowercase format and followed with last word of staff’s name and ‘@oosalon.com’ 
--word) for every staff who handle transaction on Thursday. The duplicated data must 
--be displayed only once.
--(distinct, lower, left, reverse, left, charindex, join, datename, weekday, like)
--

SELECT 
DISTINCT MsStaff.StaffName,
LOWER(LEFT(MsStaff.StaffName, 1)) +
LOWER(RIGHT(MsStaff.StaffName, CHARINDEX(' ', REVERSE(MsStaff.StaffName)) - 1 )) + '@oosalon.com' AS 'Staff Email'
FROM MsStaff JOIN  HeaderSalonServices ON HeaderSalonServices.StaffId = MsStaff.StaffId
WHERE DATENAME(WEEKDAY, HeaderSalonServices.TransactionDate) = 'Thursday';

--
--No 3
--Display New Transaction ID (obtained by replacing ‘TR’ in TransactionID with ‘Trans’), 
--Old Transaction ID (obtained from TransactionId), TransactionDate, StaffName, 
--and CustomerName for every transaction which happened 2 days before 24th December 2012. 
--(replace, join, datediff, day)
--

SELECT REPLACE(TransactionId, 'TR', 'Trans') AS [New Transaction ID],
TransactionId AS [Old Transaction ID], TransactionDate, StaffName, CustomerName
FROM HeaderSalonServices JOIN MsStaff ON MsStaff.StaffId = HeaderSalonServices.StaffId
JOIN MsCustomer ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE DATEDIFF(DAY, TransactionDate, '2012/12/24') = 2

--
--No 4
--Display New Transaction Date (obtained by adding 5 days to TransactionDate), 
--Old Transaction Date (obtained from TransactionDate), and CustomerName for every 
--transaction which didn’t happen on day 20th.
--(dateadd, day, join, datepart)
--

SELECT DATEADD(DAY, 5, TransactionDate) AS [New Transaction Date],
TransactionDate AS [Old Transaction Date], CustomerName 
FROM HeaderSalonServices JOIN MsCustomer
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE DATEPART(DAY, TransactionDate) NOT LIKE 20;

--
--No 5
--Display Day (obtained from the day transaction happened), CustomerName, and 
--TreatmentName for every Customer who was handled by female staff that has position 
--name begin with ‘TOP’ word. Then order the data based on CustomerName in ascending 
--format. 
--(datename, weekday, join, in, like, order by)
--

SELECT DATENAME(WEEKDAY, TransactionDate) AS [Day], CustomerName, TreatmentName
FROM HeaderSalonServices 
JOIN MsCustomer 
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
JOIN DetailSalonServices 
ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
JOIN MsTreatment 
ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
JOIN MsStaff 
ON MsStaff.StaffId = HeaderSalonServices.StaffId 
WHERE StaffGender IN ('Female') 
AND StaffPosition LIKE 'top%' 
ORDER BY CustomerName ASC;

--
--No 6
--Display the first data of CustomerId, CustomerName, TransactionId, Total Treatment 
--(obtained from the total number of treatment). Then sort the data based on 
--Total Treatment in descending format.
--(top, count, join, group by, order by)
--

SELECT TOP 1 MsCustomer.CustomerId, CustomerName, HeaderSalonServices.TransactionId,
COUNT(TreatmentId) AS [Total Treatment]
FROM MsCustomer 
JOIN HeaderSalonServices ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
JOIN DetailSalonServices ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
GROUP BY MsCustomer.CustomerId, 
         MsCustomer.CustomerName, 
         HeaderSalonServices.TransactionId
ORDER BY [Total Treatment] DESC;

--
--No 7
--Display CustomerId, TransactionId, CustomerName, and Total Price 
--(obtained from total amount of price) for every transaction with total price is 
--higher than the average value of treatment price from every transaction. 
--Then sort the data based on Total Price in descending format.
--(sum, join, alias subquery,avg, group by, having, order by)
--

SELECT MsCustomer.CustomerId, HeaderSalonServices.TransactionId, MsCustomer.CustomerName, 
SUM(MsTreatment.Price) AS 'Total Price'
FROM MsCustomer
JOIN  HeaderSalonServices ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId 
JOIN  DetailSalonServices ON DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId 
JOIN  MsTreatment ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId 
GROUP BY MsCustomer.CustomerId, 
         HeaderSalonServices.TransactionId, 
         MsCustomer.CustomerName 
HAVING
SUM(Price) > (
    SELECT AVG(a.Result) FROM (
    SELECT SUM(Price) AS Result FROM MsTreatment JOIN DetailSalonServices 
    ON MsTreatment.TreatmentId = DetailSalonServices.TreatmentId 
    GROUP BY TransactionId) AS a) 
ORDER BY 'Total Price' DESC;

--
--No 8
--Display Name (obtained by adding ‘Mr. ’ in front of StaffName), StaffPosition, and 
--StaffSalary for every male staff. The combine it with Name (obtained by adding ‘Ms. ’
-- in front of StaffName), StaffPosition, and StaffSalary for every female staff. 
--Then sort the data based on Name and StaffPosition in ascending format.
--(union, order by)
--

SELECT 'Mr. ' + StaffName AS 'StaffName', StaffPosition, StaffSalary
FROM MsStaff
WHERE StaffGender LIKE 'Male'
UNION -- nyatuin
SELECT 'Ms. ' + StaffName AS 'StaffName', StaffPosition, StaffSalary
FROM MsStaff
WHERE StaffGender LIKE 'Female'
ORDER BY 'StaffName' ASC;

--
--No 9
--Display TreatmentName, Price (obtained by adding ‘Rp. ’ in front of Price), and 
--Status as ‘Maximum Price’ for every Treatment which price is the highest 
--treatment’s price. Then combine it with TreatmentName, Price (obtained by 
--adding ‘Rp. ’ in front of Price), and Status as ‘Minimum Price’ for every 
--Treatment which price is the lowest treatment’s price.
--(cast, max, alias subquery, union, min)
--

SELECT TreatmentName, concat('Rp. ',Price) AS Price, 'Minimum Price' AS Status
FROM MsTreatment, (SELECT MIN(Price) as a FROM MsTreatment) as b
WHERE Price LIKE b.a  -- Min Price
UNION
SELECT TreatmentName, concat('Rp. ',Price) AS Price, 'Maximum Price' AS Status
FROM MsTreatment, (SELECT MAX(Price) as a FROM MsTreatment) as b
WHERE Price LIKE b.a  -- Min Price

SELECT * FROM MsStaff WHERE StaffId IN (SELECT StaffId FROM MsStaff WHERE StaffSalary > 7000000);

SELECT a.studentid, a.name, b.total_marks
FROM student a, marks b
WHERE a.studentid = b.studentid AND b.total_marks >
(SELECT total_marks
FROM marks
WHERE studentid =  'V002');

--
--No 10
--Display Longest Name of Staff and Customer (obtained from CustomerName), 
--Length of Name (obtained from length of customer’s name), Status as ‘Customer’ for 
--every customer who has the longest name. Then combine it with Longest Name of Staff 
--and Customer (obtained from StaffName), Length of Name (obtained from length of 
--staff’s name), Status as ‘Staff’ for every staff who has the longest name
--(len, max, alias subquery, union)
--

SELECT CustomerName, LEN(CustomerName) AS 'Length of Name', 'Customer' AS 'Status'
FROM MsCustomer, (SELECT MAX(LEN(CustomerName)) as a FROM MsCustomer) as b
WHERE LEN(CustomerName) LIKE b.a
UNION
SELECT StaffName, LEN(StaffName) AS 'Length of Name', 'Staff' AS 'Status'
FROM MsStaff, (SELECT MAX(LEN(StaffName)) as a FROM MsStaff) as b
WHERE LEN(StaffName) LIKE b.a

SELECT StaffName, LEN(StaffName) AS 'Length of Name', 'Staff' AS 'Status'
FROM MsStaff
WHERE LEN(StaffName) LIKE (SELECT  MAX(LEN(StaffName)) FROM MsStaff);


select TreatmentName, concat('Rp. ', Price) as Price, 'Minimum Price' as Status
from MsTreatment, (select min(price) as a from MsTreatment) as b
where price like b.a
union
select TreatmentName, concat('Rp. ', Price)as Price, 'Maximum Price' as Status
from MsTreatment, (select max (price) as a from MsTreatment) as b
where price like b.a



--
-- Modul 7
--

--
-- No 1
--Display TreatmentId, and TreatmentName for every treatment which id is ‘TM001’ or ‘TM002’.
--(in)
--

SELECT TreatmentId, TreatmentName
FROM MsTreatment
WHERE TreatmentId IN ('TM001', 'TM002');

--
--No 2
--Display TreatmentName, and Price for every treatment which type is not ‘Hair Treatment’ and ‘Message / Spa’.
--(in, not in)
--

SELECT TreatmentName, Price
FROM MsTreatment JOIN MsTreatmentType 
ON MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
AND TreatmentTypeName NOT IN ('Hair Treatment')
AND TreatmentTypeName NOT IN ('Hair Spa Treatment');

--
--No 3
--Display CustomerName, CustomerPhone, and CustomerAddress for every customer whose name is more than 8 charactes and did transaction on Friday.
--(len, in, datename, weekday)
--

SELECT CustomerName, CustomerPhone, CustomerAddress
FROM MsCustomer, HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND LEN(CustomerName) > 8
AND DATENAME(WEEKDAY, TransactionDate) = 'Friday';

--
--No 4
--Display TreatmentTypeName, TreatmentName, and Price for every treatment that taken 
--by customer whose name contains ‘Putra’ and happened on day 22th.
--(in, like, day)
--

SELECT TreatmentTypeName, TreatmentName, Price
FROM MsTreatment, MsTreatmentType, MsCustomer, HeaderSalonServices, DetailSalonServices
WHERE MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
AND MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
AND DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
AND MsCustomer.CustomerName LIKE '%putra%'
AND DATENAME(DAY, TransactionDate) = 22;

--
--No 5
--Display StaffName, CustomerName, and TransactionDate (obtained from TransactionDate 
--in ‘Mon dd,yyyy’ format) for every treatment which the last character of treatmentid 
--is an even number.
--(convert, exists, right)
--

SELECT StaffName, CustomerName, 
CONVERT(VARCHAR, TransactionDate, 107) AS TransactionDate
FROM MsCustomer JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
JOIN MsStaff ON MsStaff.StaffId = HeaderSalonServices.StaffId
JOIN DetailSalonServices ON HeaderSalonServices.TransactionId = DetailSalonServices.TransactionId
JOIN MsTreatment ON DetailSalonServices.TreatmentId = MsTreatment.TreatmentId
AND CONVERT(INT ,RIGHT(MsTreatment.TreatmentId, 1)) % 2 = 0;

--
--No 6
--Display CustomerName, CustomerPhone, and CustomerAddress for every customer that was 
--served by staff whose name’s length is an odd number.
--(exists, len)
--

SELECT CustomerName, CustomerPhone, CustomerAddress
FROM MsCustomer
WHERE EXISTS (SELECT StaffName FROM MsStaff, HeaderSalonServices
WHERE MsStaff.StaffId = HeaderSalonServices.StaffId
AND MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND LEN(MsStaff.StaffName) % 2 != 0);

--
--No 7
--Display ID (obtained form last 3 characters of StaffID), and Name (obtained by taking 
--character after the first space until character before second space in StaffName) 
--for every staff whose name contains at least 3 words and hasn’t served male customer 
--(right, substring, charindex, len, exists, in,not like, like)
--

SELECT RIGHT(StaffId, 3) AS [ID],
SUBSTRING(SUBSTRING(MsStaff.StaffName,CHARINDEX(' ',MsStaff.StaffName)+1,
    LEN(MsStaff.StaffName)),1,CHARINDEX(' ',(SUBSTRING(MsStaff.StaffName,
    CHARINDEX(' ',MsStaff.StaffName)+1,LEN(MsStaff.StaffName)))))  AS [StaffName]
FROM MsStaff 
WHERE EXISTS (SELECT  StaffName, CustomerName
FROM HeaderSalonServices, MsCustomer
WHERE HeaderSalonServices.CustomerId = HeaderSalonServices.CustomerId
AND StaffName LIKE '% % %'
AND CustomerGender NOT LIKE 'Male');

--
--No 8
--Display TreatmentTypeName, TreatmentName, and Price for every treatment which price 
--is higher than average of all treatment’s price.
--(alias subquery, avg)
--

SELECT TreatmentTypeName, TreatmentName, Price
FROM (SELECT AVG(Price) AS Result FROM MsTreatment) AS Avg_Price, MsTreatment, MsTreatmentType
WHERE MsTreatment.TreatmentTypeId = MsTreatmentType.TreatmentTypeId
AND MsTreatment.Price > Avg_Price.Result;

--
--No 9
--Display StaffName, StaffPosition, and StaffSalary for every staff with highest salary 
--or lowest salary.
--(alias subquery, max, min)
--

SELECT StaffName, StaffPosition, StaffSalary
FROM MsStaff,(SELECT MAX(StaffSalary) AS Max_Salary, MIN(StaffSalary) 
AS Min_Salary FROM MsStaff) AS Salary
WHERE StaffSalary = Salary.Max_Salary
OR StaffSalary = Salary.Min_Salary;

--
--No 10
--Display CustomerName,CustomerPhone,CustomerAddress, and Count Treatment (obtained 
--from the total number of treatment) for every transaction which has the highest 
--total number of treatment.
--(alias subquery, group by, max, count)
--

SELECT CustomerName, CustomerPhone, CustomerAddress, a.b AS [Count Treatment]
FROM MsCustomer JOIN HeaderSalonServices ON MsCustomer.CustomerId=HeaderSalonServices.CustomerId
JOIN 
(SELECT TransactionId, COUNT(TreatmentId) AS [b]
FROM DetailSalonServices GROUP BY TransactionId) AS [a] ON HeaderSalonServices.TransactionId = a.TransactionId
WHERE a.b = (SELECT MAX(b)
FROM (SELECT TransactionId, COUNT(TreatmentId) AS [b] FROM DetailSalonServices GROUP BY TransactionId) AS [a])


--
--Modul 8
--

--
--No 1
--

CREATE VIEW ViewBonus AS
SELECT REPLACE(CustomerId, 'CU', 'BN') AS [BinusID], CustomerName
FROM MsCustomer WHERE LEN(CustomerName) > 10

SELECT * FROM ViewBonus

--
--No 2
--

CREATE VIEW ViewCustomerData AS
SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName)) AS [Name],
CustomerAddress AS [Address], CustomerPhone AS Phone
FROM MsCustomer
WHERE CustomerName LIKE '% %'

SELECT * FROM ViewCustomerData

--
--No 3
--Create a view named ‘ViewTreatment’ to display TreatmentName, TreatmentTypeName, 
--Price (obtained from Price by adding ‘Rp. ’ in front of Price) for every treatment
--which type is ‘Hair Treatment’ and price is between 450000 and 800000.
--(create view, cast, between)
--

CREATE VIEW ViewTreatment AS
SELECT TreatmentName, TreatmentTypeName,
'Rp.' + CAST(Price AS VARCHAR) AS [Price]
FROM MsTreatment, MsTreatmentType
WHERE MsTreatmentType.TreatmentTypeId = MsTreatment.TreatmentTypeId
AND TreatmentTypeName = 'Hair Treatment'
AND Price BETWEEN 450000 AND 800000

--
--No 4
--Create a view named ‘ViewTransaction’ to display StaffName, CustomerName, 
--TransactionDate (obtained from TransactionDate in ‘dd mon yyyy’ format), and 
--PaymentType for every transaction which the transaction is between 21st and 25th day 
--and was paid by ‘Credit’.
--(create view, convert, day, between)

CREATE VIEW ViewTransaction AS
SELECT StaffName, CustomerName, 
CONVERT(DATE, TransactionDate, 106) AS [TransactionDate], PaymentType
FROM MsStaff, MsCustomer, HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND MsStaff.StaffId = HeaderSalonServices.StaffId
AND DAY(HeaderSalonServices.TransactionDate) BETWEEN 21 AND 25
AND PaymentType = 'Credit'

--Date format still wrong

--
--No 5
--Create a view named ‘ViewBonusCustomer’ to display BonusId (obtained from CustomerId 
--by replacing ‘CU’ with ‘BN’), Name (Obtained from CustomerName by taking the next 
--character after space until the last character in lower case format), Day (obtained 
--from the day when the transaction happened), and TransactionDate (obtained from 
--TransactionDate in ‘mm/dd/yy’ format) for every transaction which customer’s name 
--contains space and staff’s last name contains ‘a’ character.
--(create view, replace, lower, substring, charindex, len, datename, weekday, convert, 
--like)
--

CREATE VIEW ViewBonusCustomer AS
SELECT REPLACE(MsCustomer.CustomerId, 'CU', 'BN') AS [BonusId],
LOWER(SUBSTRING(CustomerName, CHARINDEX(' ', CustomerName), 
LEN(MsCustomer.CustomerName))) AS [Name],
DATENAME(WEEKDAY, HeaderSalonServices.TransactionDate) AS [Day],
CONVERT(DATE, HeaderSalonServices.TransactionDate, 109) AS [TransactionDate]
FROM MsCustomer, HeaderSalonServices
WHERE MsCustomer.CustomerId = HeaderSalonServices.CustomerId
AND CustomerName LIKE '% %'
AND CustomerName LIKE '%a'

--Date format still wrong

--
--No 6
--Create a view named ‘ViewTransactionByLivia’ to display TransactionId, Date 
--(obtained from TransactionDate in ‘Mon dd, yyyy’ format), and TreatmentName for 
--every transaction which occurred on the 21st day and handled by staff whose name 
--is ‘Livia Ashianti’.
--(create view, convert, day, like)
--

CREATE VIEW ViewTransactionByLivia AS
SELECT HeaderSalonServices.TransactionId,
CONVERT(DATE, TransactionDate, 107) AS [Date],TreatmentName
FROM MsStaff, MsTreatment, HeaderSalonServices, DetailSalonServices
WHERE MsStaff.StaffId = HeaderSalonServices.StaffId
AND MsTreatment.TreatmentId = DetailSalonServices.TreatmentId
AND DetailSalonServices.TransactionId = HeaderSalonServices.TransactionId
AND DAY(TransactionDate) = 21
AND MsStaff.StaffName LIKE 'Livia Ashianti'

SELECT * FROM ViewTransactionByLivia

--
--No 7
--Change the view named ‘ViewCustomerData’ to ID (obtained from the last 3 digit 
--characters of CustomerID), Name (obtained from CustomerName), Address (obtained from 
--CustomerAddress), and Phone (obtained from CustomerPhone) for every customer whose 
--name contains space.
--(alter view, right, charindex)
--

ALTER VIEW ViewCustomerData AS
SELECT RIGHT(CustomerId, CHARINDEX('U', CustomerId) + 1) AS "ID", CustomerName AS [Name],
CustomerAddress AS [Address], CustomerPhone AS [Phone] FROM MsCustomer
WHERE CustomerName LIKE '% %'

--
--No 8
--

CREATE VIEW ViewCustomer AS
SELECT * FROM MsCustomer
INSERT INTO ViewCustomer (CustomerId, CustomerName, CustomerGender)
VALUES ('CU006', 'Christian', 'Male')

SELECT * FROM ViewCustomer

--
--No 9
--Delete data in view ‘ViewCustomerData’ that has ID ‘005’. Then display all data 
--from ViewCustomerData.
--(delete)

SELECT * FROM ViewCustomerData;
DELETE FROM ViewCustomerData WHERE ID = '005'

--
--No 10
--Delete the view named ‘ViewCustomerData’.
--(drop view)
--

DROP VIEW ViewCustomerData


--
--Modul 9
--

--
--No 1
--Create login named ‘ManagerUser’. (create login)
--

CREATE LOGIN ManagerUser WITH PASSWORD = 'Wibu_Ras_Terkuat_diBumi';

--
--No 2
--Create user named ‘Manager’ for ManagerUser login. 
--(create user)
--

CREATE USER Manager FOR LOGIN ManagerUser;

--
--No 3
--Create login named ‘EmployeeUser’. 
--(create login)
--

CREATE LOGIN EmployeeUser WITH PASSWORD = 'Wibu_Ras_Terkuat_diBumi';

--
--No 4
--Create user named ‘Employee’ for EmployeeUser login. 
--(create user)
--

CREATE USER Employee FOR LOGIN EmployeeUser;

--
--No 5
--Remove update privilege on MsStaff table from Manager. 
--(revoke)
--

REVOKE UPDATE ON MsStaff FROM Manager CASCADE;

--
--No 6
--Give all privileges on MsTreatment table to public. 
--(grant)
--

GRANT ALL ON MsStaff TO Manager;

--
--No 7
--Give insert, update, delete privileges to Manager on MsStaff table and the manager 
--can give privilege to another user.
--(grant, with grant option)
--

GRANT INSERT, UPDATE, DELETE ON MsStaff TO Manager WITH GRANT OPTION;

--
--No 8
--Give select privilege on MsTreatmentType table to Manager. 
--(grant, to)
--

GRANT SELECT ON MsTreatmentType TO Manager;

--
--No 9
--Remove all privileges on MsTreatment table from public. (revoke)
--

REVOKE ALL ON MsTreatment FROM PUBLIC;

--
--No 10
--Remove update privilege on MsStaff table from Manager. (revoke)
--

REVOKE UPDATE ON MsStaff FROM Manager CASCADE;

--
--Modul 10
--

--
--No 1
--Create a store procedure with named ‘sp1’ to display CustomerId, CustomerName, 
--CustomerGender, and CustomerAddress for every Customer with Id based on user’s input.
--(create procedure)
--

GO
CREATE PROCEDURE [sp1] @Id CHAR(5)
AS SELECT CustomerId, CustomerName, CustomerGender, CustomerAddress 
FROM MsCustomer
WHERE CustomerId = @Id;

EXEC sp1 'CU001';

--
--No 2
-- Create a store procedure with named ‘sp2’ that receives CustomerName as input from 
--user with the following specification:
-- - If the length of CustomerName is odd then procedure will give output ‘Character 
--Length of Mentor Name is an Odd Number’.
-- - If the length of CustomerName is even then procedure will display CustomerId, 
--CustomerName, CustomerGender, TransactionId, and TransactionDate for every transaction 
--with customer whose name contains the name that was inputted by user.
--(create procedure, len, like)

GO
CREATE PROCEDURE [sp2] @name VARCHAR(50)
AS 
IF LEN(@name) % 2 = 1
PRINT 'Character Length of Customer Name is an Odd Number' 
ELSE
SELECT MsCustomer.CustomerId, CustomerName, CustomerGender, TransactionId, TransactionDate
FROM MsCustomer JOIN HeaderSalonServices 
ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE CustomerName LIKE '%' + @name + '%'; 

EXEC sp2 'Elysia Chen';

EXEC sp2 'Fran';

--
--No 3
--Create a store procedure named ‘sp3’ to update StaffId, StaffName, StaffGender, 
--and StaffPhone on MsStaff table based on StaffId, StaffName, StaffGender, and 
--StaffPhone that was inputted by user. Then display the updated data if the StaffId 
--exists in MsStaff table. Otherwise show message ‘Staff does not exists’.
--(create procedure, update, exists)
--
Drop PROCEDURE [sp3]

GO
CREATE PROCEDURE [sp3] @id CHAR(5), @name VARCHAR(50), @gender VARCHAR(10), @phone VARCHAR(13)
AS
BEGIN
IF EXISTS(
SELECT StaffId FROM MsStaff 
WHERE StaffId = @id AND StaffName = @name AND StaffGender = @gender AND StaffPhone = @phone)
BEGIN
--Update data
UPDATE MsStaff
SET StaffId = @id, StaffName = @name, StaffGender = @gender, StaffPhone = @phone
WHERE StaffId = @id
--For checking if data has been updated
SELECT * FROM MsStaff WHERE StaffId = @id
END
ELSE 
PRINT 'Staff Does not Exists'
END;

EXEC [sp3] 'SF005', 'Ryan Nixon', 'M', '08567756123'

--
--No 4
--

drop TRIGGER [trig1]
GO
CREATE TRIGGER [trig1]
ON MsCustomer
FOR UPDATE
AS
BEGIN
SELECT * FROM INSERTED
UNION
SELECT * FROM DELETED
END

BEGIN TRANSACTION UPDATE MsCustomer SET CustomerName = 'Franky Quo' WHERE CustomerId= 'CU001' SELECT * FROM MsCustomer ROLLBACK

--
--No 5
--

GO
CREATE TRIGGER [trig2]
ON MsCustomer
AFTER INSERT
AS
BEGIN
DELETE TOP(1)
FROM MsCustomer
END

INSERT INTO MsCustomer
VALUES ('CU006', 'Yogie Soesanto', 'Male', '085562133000', 'Pelsakih Street no 52')
SELECT * FROM MsCustomer

INSERT INTO MsCustomer
VALUES ('CU001', 'Franky', 'Male', '08566543338', 'Daan mogot baru Street no 6')

INSERT INTO MsCustomer
VALUES ('CU002', 'Ernalia Dewi', 'Female', '085264782135', 'Tanjung Duren Street no 185')

SELECT * FROM MsCustomer

DELETE FROM MsCustomer WHERE CustomerId='CU006';
drop TRIGGER [trig2]

--
--No6
--

GO
CREATE TRIGGER [trig3]
ON MsCustomer
FOR DELETE
AS
BEGIN
IF OBJECT_ID('REMOVED') IS NOT NULL
BEGIN
INSERT INTO [REMOVED]
SELECT * FROM MsCustomer
END
ELSE
BEGIN
SELECT * INTO [REMOVED] FROM MsCustomer
END
END;

BEGIN TRANSACTION
DELETE FROM MsCustomer
WHERE CustomerId = 'CU002'
SELECT * FROM MsCustomer
SELECT * FROM [REMOVED]


DROP TRIGGER [trig3]

--
--No 7
--

GO
DECLARE @name VARCHAR (50)
DECLARE [cur1] CURSOR FOR
SELECT StaffName FROM MsStaff
OPEN [cur1]
FETCH NEXT FROM [cur1] INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
IF (LEN (@name) %2 = 0)
BEGIN
PRINT ('The leght from StaffName '+ @name +' is an odd number')
END
BEGIN
PRINT ('The leght from StaffName '+ @name +' is an even number')
END
FETCH NEXT FROM [cur1] INTO @name
END

CLOSE cur1
DEALLOCATE cur1

--
--No 8
--

GO
CREATE PROCEDURE [sp4] @search VARCHAR(50)
AS 
BEGIN
DECLARE [cur2] CURSOR
FOR
SELECT StaffName, StaffPosition
FROM MsStaff
WHERE StaffName LIKE '%' + @search + '%'
DECLARE 
@name VARCHAR(50),
@position VARCHAR(20)
OPEN [cur2]  
FETCH NEXT FROM [cur2] INTO @name, @position
IF @@FETCH_STATUS <> 0
PRINT 'Cursor Fetch Failed!'
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'StaffName : ' + @name + ' : ' + @position
FETCH NEXT FROM [cur2] INTO @name, @position
END
CLOSE [cur2]
DEALLOCATE [cur2]
END

EXEC [sp4] 'a'

DROP PROCEDURE [sp4]

--
--No9
--

GO
CREATE PROCEDURE [sp5] @id CHAR(5)
AS
BEGIN
DECLARE [cur3] CURSOR
FOR
SELECT  MsCustomer.CustomerName, HeaderSalonServices.TransactionDate
FROM MsCustomer
JOIN HeaderSalonServices
ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE MsCustomer.CustomerId IN (@id)
DECLARE @name VARCHAR(50), @date DATE
OPEN [cur3]
FETCH NEXT FROM [cur3] INTO @name, @date
IF @@FETCH_STATUS <> 0
PRINT 'Cursor Fetch Failed!'
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'Customer Name : ' + @name + ' Transaction Date is ' + CAST(@date AS VARCHAR)
FETCH NEXT FROM [cur3] INTO @name, @date
END
CLOSE [cur3]
DEALLOCATE [cur3]
END

EXEC [sp5] 'CU003'
drop PROCEDURE [sp5]

--
--No 10
--10. Delete all procedure and trigger that has been made.
--

GO
DROP PROCEDURE [sp1], [sp2], [sp3], [sp4], [sp5]
DROP TRIGGER trig1, trig2, trig3