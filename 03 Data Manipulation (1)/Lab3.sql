INSERT INTO MsStaff
VALUES ('SF006', 'Jeklin Harefa', 'Female', '085265433322', 'Kebon Jeruk Street no 140', '3000000', 'Stylist'),
('SF007', 'Lavinia', 'Female', '085755500011', 'Kebon Jeruk Street no 153', '3000000', 'Stylist'), 
('SF008', 'Stephen Adrianto', 'Male', '085564223311', 'Mandala Street no 14', '3000000', 'Stylist'),
('SF009', 'Rico Wijaya', 'Male', '085710252525', 'Keluarga Street no 78', '3000000', 'Stylist')

INSERT INTO HeaderSalonServices
VALUES ('TR010', 'CU001', 'SF004', '2012/12/23', 'Credit'),
('TR011', 'CU002', 'SF006', '2012/12/24', 'Credit'),
('TR012', 'CU003', 'SF007', '2012/12/24', 'Cash'),
('TR013', 'CU004', 'SF005', '2012/12/25', 'Debit'),
('TR014', 'CU005', 'SF007', '2012/12/25', 'Debit'),
('TR015', 'CU005', 'SF005', '2012/12/26', 'Credit'),
('TR016', 'CU002', 'SF001', '2012/12/26', 'Cash'),
('TR017', 'CU003', 'SF002', '2012/12/26', 'Credit'),
('TR018', 'CU005', 'SF001', '2012/12/27', 'Debit')


INSERT INTO DetailSalonServices
VALUES ('TR010', 'TR010'),
('TR010', 'TM005'),
('TR010', 'TM010'),
('TR011', 'TM015'),
('TR011', 'TM025'),
('TR012', 'TM009'),
('TR013', 'TM003'),
('TR013', 'TM006'),
('TR013', 'TM015'),
('TR014', 'TM016'),
('TR015', 'TM016'),
('TR015', 'TM006'),
('TR016', 'TM015'),
('TR016', 'TM003'),
('TR016', 'TM005'),
('TR017', 'TM003'),
('TR018', 'TM006'),
('TR018', 'TM005'),
('TR018', 'TM007')

insert into HeaderSalonServices
values ('TR019', 'CU005', 'SF004', dateadd (day,3,getdate()), 'Credit')

SELECT * FROM HeaderSalonServices
WHERE TransactionId = 'TR019'

insert into MsStaff
values ('SF010', 'Effendy Lesmana', 'Male', '085218587878', 'Tanggerang City Street no 88', round (rand()*(5000000-3000000)+3000000,0),'Stylist')

SELECT * FROM MsStaff
WHERE StaffId = 'SF010'

UPDATE MsCustomer
SET CustomerPhone = replace (CustomerPhone, '08', '628')
WHERE CustomerPhone like '08%'

SELECT * FROM MsCustomer

update MsStaff
set StaffSalary = StaffSalary + 7000000, StaffPosition = REPLACE (StaffPosition, 'Stylist', 'Top Stylist')
where StaffName like 'Effendy Lesmana'

SELECT * FROM MsStaff

select *from MsCustomer

update MsCustomer
set CustomerName = left (CustomerName, CHARINDEX(' ', CustomerName))
from MsCustomer join HeaderSalonServices
on MsCustomer.CustomerId = HeaderSalonServices.CustomerId
where datepart (day, TransactionDate) = '24'


UPDATE MsCustomer
SET CustomerName = REPLACE(CustomerName, 'Ernalia', 'Ernalia Dewi')
WHERE CustomerName = 'Ernalia'

UPDATE MsCustomer
SET CustomerName = REPLACE(CustomerName, 'Elysia', 'Elysia Chen')
WHERE CustomerName = 'Elysia'

SELECT * FROM MsCustomer

update MsCustomer
set CustomerName = 'Ms. ' + CustomerName
where CustomerName in ('Ernalia Dewi', 'Elysia Chen')

update MsCustomer
set CustomerAddress = 'Daan Mogot Baru Street No. 23'
where exists (select CustomerId from HeaderSalonServices
where(MsCustomer.CustomerId = HeaderSalonServices.CustomerId)
and (StaffId in (select StaffId from MsStaff where StaffName = 'Indra Saswita')) and (datename (weekday, TransactionDate) = 'Thursday'))

select *from HeaderSalonServices

DELETE HeaderSalonServices FROM HeaderSalonServices join MsCustomer on HeaderSalonServices.CustomerId = MsCustomer.CustomerId
WHERE  CHARINDEX (' ', CustomerName) = 0

select *from MsTreatment

delete from MsTreatment  
where TreatmentTypeId in (select TreatmentTypeId from MsTreatmentType where TreatmentTypeName not like '%Treatment')






