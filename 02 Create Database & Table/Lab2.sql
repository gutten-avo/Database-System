-- Lab Session 2

-- Topic : 
-- Introducing table and referential integrity
-- Primary and Foreign Key
-- Constraint Value
-- Drop Table
-- Alter Table


-- 1. create table, like

CREATE TABLE MsCustomer (
	CustomerId CHAR(5) NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(50),
	CustomerGender VARCHAR(10),
	CustomerPhone VARCHAR(13),
	CustomerAddress VARCHAR(100),
	CONSTRAINT Check_CustId CHECK (CustomerId LIKE ('CU[0-9][0-9][0-9]')),
	CONSTRAINT Check_CustGen CHECK (CustomerGender IN ('Male', 'Female'))
);

CREATE TABLE MsStaff (
	StaffId CHAR(5) NOT NULL PRIMARY KEY,
	StaffName VARCHAR(50),
	StaffGender VARCHAR(10),
	StaffPhone VARCHAR(13),
	StaffAddress VARCHAR(100),
	StaffSalary NUMERIC(11,2),
	StaffPosition VARCHAR(20),
	CONSTRAINT Check_StaffId CHECK (StaffId LIKE ('SF[0-9][0-9][0-9]')),
	CONSTRAINT Check_StaffGen CHECK (StaffGender IN ('Male','Female'))
);

CREATE TABLE MsTreatmentType (
	TreatmentTypeId CHAR(5) NOT NULL PRIMARY KEY,
	TreatmentTypeName VARCHAR(50),
	CONSTRAINT Check_TreatId CHECK (TreatmentTypeId LIKE ('TT[0-9][0-9][0-9]'))
);

CREATE TABLE MsTreatment (
	TreatmentId CHAR(5) NOT NULL PRIMARY KEY,
	TreatmentTypeId CHAR(5) NOT NULL,
	TreatmentName VARCHAR(50),
	Price NUMERIC(11,2),
	CONSTRAINT Check_TreatmId CHECK (TreatmentId LIKE ('TM[0-9][0-9][0-9]')),
	FOREIGN KEY (TreatmentTypeId) REFERENCES MsTreatmentType(TreatmentTypeId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE HeaderSalonServices (
	TransactionId CHAR(5) NOT NULL PRIMARY KEY,
	CustomerId CHAR(5) NOT NULL,
	StaffId CHAR(5) NOT NULL,
	TransactionDate DATE,
	PaymentType VARCHAR(20),
	CONSTRAINT Check_TransId CHECK (TransactionId LIKE ('TR[0-9][0-9][0-9]')),
	FOREIGN KEY (CustomerId) REFERENCES MsCustomer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (StaffId) REFERENCES MsStaff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DetailSalonServices (
	TransactionId CHAR(5) NOT NULL,
	TreatmentId CHAR(5) NOT NULL,
	FOREIGN KEY (TransactionId) REFERENCES HeaderSalonServices(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (TreatmentId) REFERENCES MsTreatment(TreatmentId) ON UPDATE CASCADE ON DELETE CASCADE
);


-- 2. drop table

DROP TABLE DetailSalonServices


-- 3. create table, alter table, primary key

CREATE TABLE DetailSalonServices (
	TransactionId CHAR(5) NOT NULL,
	TreatmentId CHAR(5) NOT NULL,
	FOREIGN KEY (TransactionId) REFERENCES HeaderSalonServices(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (TreatmentId) REFERENCES MsTreatment(TreatmentId) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE DetailSalonServices 
ADD CONSTRAINT PK_DetailId PRIMARY KEY (TransactionId, TreatmentId);


-- 4. alter table, with nocheck, add constraint, drop

ALTER TABLE MsStaff WITH NOCHECK
ADD CONSTRAINT Check_Len CHECK (LEN(StaffName) <= 5 AND LEN(StaffName) >= 20);

ALTER TABLE MsStaff
DROP CONSTRAINT Check_len;


-- 5. alter table, add, drop column

ALTER TABLE MsTreatment
ADD Desciption VARCHAR(100);

ALTER TABLE MsTreatment
DROP COLUMN Desciption;