/* Enterprises Referral Management System */
/* Group 2: Long Wan, Jiayi Yu, Lu Yin */


/********************/
/*   drop tables    */
/********************/
/* Delete the tables, triggers and views if they already exist. */
DROP TABLE IF EXISTS EmploymentHistory;
DROP TABLE IF EXISTS Fired;
DROP TABLE IF EXISTS Resign;
DROP TABLE IF EXISTS Former;
DROP TABLE IF EXISTS SuccessRef;
DROP TABLE IF EXISTS Referral;
DROP TABLE IF EXISTS Application;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Applicant;
DROP TABLE IF EXISTS Position;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS CompanyBranch;
DROP VIEW IF EXISTS  SearchAvailablePosition;
DROP VIEW IF EXISTS  NewEmployee1Year;
DROP VIEW IF EXISTS  SuccessReferralHistory;
DROP VIEW IF EXISTS EmploymentHistoryView;
DROP TRIGGER IF EXISTS AppToEmp;
DROP TRIGGER IF EXISTS ResignToFormer;
DROP TRIGGER IF EXISTS FiredToFormer;
DROP TRIGGER IF EXISTS FiredForNonDownsizing;
DROP TRIGGER IF EXISTS NewReferreeAcceptance;
DROP TRIGGER IF EXISTS ReferreeBecomeFormer1Year;
DROP TRIGGER IF EXISTS PositionUpdate;
DROP TRIGGER IF EXISTS FormerToHistory;
DROP TRIGGER IF EXISTS AvailablePositionChange;

/********************/
/*   create tables  */
/********************/
/* Holds information regarding branch, including its name and address */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TABLE CompanyBranch(
	BranchID  VARCHAR(10) PRIMARY KEY,
	City  VARCHAR(100)
	/* CHECK( BranchID IN (SELECT BranchID FROM Department)) */
);

/* Holds department information, including its name, email address and affiliation to branch */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TABLE Department(
	DepID  VARCHAR(10),
	BranchID  VARCHAR(10),
	DepName  VARCHAR(50),
	Email  VARCHAR(50),
	PRIMARY KEY(BranchID, DepID),
	FOREIGN KEY(BranchID) 
		REFERENCES CompanyBranch (BranchID) 
			ON DELETE CASCADE
			ON UPDATE CASCADE
	/* CHECK((BranchID, DepID) IN (SELECT BranchID,DepID FROM Position) */
);

/* Holds position information, including its id, name, level, available quantity and affiliation */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TABLE Position(
	PosID  VARCHAR(10),
	DepID   VARCHAR(10),
	BranchID   VARCHAR(10),
	PosName  VARCHAR(50),
	PosLevel VARCHAR(50),
	BaseSalary INT, 
	AvailableQ INT,
FOREIGN KEY(DepID,BranchID) 
	REFERENCES Department (DepID,BranchID) 
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	PRIMARY KEY(BranchID, DepID, PosID)
);

/*Holds the information of all applicants*/
/* Author: Lu Yin Reviewer: Long Wan, Jiayi Yu */
CREATE TABLE Applicant(
	ApplicantID VARCHAR(10),
       	Name VARCHAR(50),
       	Gender VARCHAR(50),
       	DOB VARCHAR(50),
       	PRIMARY KEY(ApplicantID)
	/* CHECK ( ApplicantID IN (SELECT ApplicantID FROM Application)) */
);

/* Holds information about an employee. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
CREATE TABLE Employee(
	EmployeeID VARCHAR(10),
	Name VARCHAR(50),
	Gender VARCHAR(50),
	DOB DATE,
	Salary REAL,
	EmployDate DATE,
	BaseBonus INT,
	PRIMARY KEY (EmployeeID)
/* CHECK(EmployeeID IN (SELECT EmployeeID FROM EmployementHistory) */
	);

/*Holds information of all applications*/
/* Author: Lu Yin Reviewer: Long Wan, Jiayi Yu */
CREATE TABLE Application(
	ApplicationID VARCHAR(10),
       	ApplicantID  VARCHAR(10) NOT NULL,
       	EmployeeID  VARCHAR(10),
	PosID VARCHAR(10) ,
	DepID VARCHAR(10) ,
	BranchID VARCHAR(10) ,
       	IfAdmitted  BOOLEAN DEFAULT NULL,
       	Acceptance BOOLEAN DEFAULT NULL,
       	ApplyDate  DATE,
       	Resume VARCHAR,
	PRIMARY KEY(ApplicationID),
	FOREIGN KEY (EmployeeID) 
REFERENCES Employee (EmployeeID)
ON DELETE NO ACTION 
ON UPDATE CASCADE,
       	FOREIGN KEY (ApplicantID) 
REFERENCES Applicant (ApplicantID) 
ON DELETE NO ACTION 
ON UPDATE CASCADE,
	FOREIGN KEY(BranchID, DepID, PosID) 
REFERENCES Position (BranchID, DepID, PosID) 
ON DELETE SET NULL 
ON UPDATE CASCADE
/* CHECK ( (BranchID, PosID,depID) IN ( 
	SELECT BranchID,PosID,depID
	FROM Position P
	WHERE P.AvailableQ=0  )) */
);

/*Records information of the referral*/
/* Author: Lu Yin Reviewer: Long Wan, Jiayi Yu */
CREATE TABLE Referral(
RefID  VARCHAR(10),
      	ApplicationID VARCHAR(10) NOT NULL,
	EmployeeID VARCHAR(10) NOT NULL,
           RefDate  DATE,
       	SupportingLetter VARCHAR,
       	PRIMARY KEY(RefID),
FOREIGN KEY (ApplicationID) 
REFERENCES Application(ApplicationID) 
ON DELETE NO ACTION  
ON UPDATE CASCADE,
FOREIGN KEY (EmployeeID) 
REFERENCES Employee (EmployeeID) 
ON DELETE NO ACTION  
ON UPDATE CASCADE
);

/*Holds the referral ID and bonus pay for success referral*/
/* Author: Lu Yin Reviewer: Long Wan, Jiayi Yu */
CREATE TABLE SuccessRef(
	RefID VARCHAR(10),
	BonusPay INT,
	PRIMARY KEY(RefID),
	FOREIGN KEY (RefID) 
REFERENCES Referral (RefID) 
ON DELETE NO ACTION 
ON UPDATE CASCADE
);

/* Holds information about a former employee. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
CREATE TABLE Former (
	EmployeeID VARCHAR(10)  PRIMARY KEY,
	DimDate DATE,
	FOREIGN KEY (EmployeeID) 
REFERENCES Employee (EmployeeID) 
ON DELETE NO ACTION 
ON UPDATE CASCADE
	/* CHECK (EmployeeID NOT IN (SELECT EmployeeID FROM Fired 
UNION SELECT EmployeeID FROM Resign )) */
);

/* Holds information about resigned employees. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
CREATE TABLE Resign(
	EmployeeID VARCHAR(10)  PRIMARY KEY,
	ResignReason VARCHAR(50) NOT NULL,
	FOREIGN KEY (EmployeeID)  
REFERENCES Former (EmployeeID) 
ON DELETE NO ACTION 
ON UPDATE CASCADE
	/* CHECK (EmployeeID NOT IN (SELECT EmployeeID FROM Fired)) */
);

/* Holds information about fired employees. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
CREATE TABLE Fired(
	EmployeeID VARCHAR(10)  PRIMARY KEY,
	FiredReason VARCHAR(50) NOT NULL,
	FOREIGN KEY (EmployeeID) 
REFERENCES Former(EmployeeID) 
ON DELETE NO ACTION 
ON UPDATE CASCADE
	/* CHECK (EmployeeID NOT IN (SELECT EmployeeID FROM Resign)) */
);

/* Holds information about employment history for an employee within the company */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TABLE EmploymentHistory(
	EmployeeID VARCHAR(10) NOT NULL,
	StartDate DATE,
	EndDate DATE,
	PosID VARCHAR(10) , 
	DepID VARCHAR(10) ,
	BranchID VARCHAR(10),
	PRIMARY KEY(EmployeeID, StartDate),
	FOREIGN KEY(PosID, DepID, BranchID)
		REFERENCES Position(PosID, DepID, BranchID)
			ON DELETE SET NULL
			ON UPDATE CASCADE,
	FOREIGN KEY(EmployeeID)
		REFERENCES Employee
			ON UPDATE CASCADE
	/* add check to avoid inconsistency: current position in EmploymentHistory table should be consistent with that in Employee table for a specific person */
	/* CHECK(NOT EXISTS(
SELECT EmployeeID, PosID, DepID, BranchID
FROM Employee
WHERE EmployeeID NOT IN (
SELECT EmployeeID
FROM Former)
EXCEPT
SELECT EmployeeID, PosID, DepID, BranchID
FROM EmploymentHistory
WHERE EndDate is NULL)) */
/* add check to avoid inconsistency: current employee"s employment date should be consistent with the start date of the person"s first record in History */
	/* CHECK(NOT EXISTS(SELECT EmployeeID, EmployDate
FROM Employee
WHERE EmployeeID NOT IN(SELECT EmployeeID 
			FROM Former)
		EXCEPT
		SELECT temp1.EmployeeID, temp2.EmployDate
		FROM (SELECT DISTINCT EmployeeID
			FROM EmploymentHistory
			WHERE EndDate IS NULL) temp1,
		(SELECT MIN(StartDate) AS EmployDate, EmployeeID
		FROM EmploymentHistory
		GROUP BY EmployeeID) temp2
		WHERE temp1.EmployeeID = temp2.EmployeeID
)) */
);

/********************/
/*  insert values   */
/********************/
/*Sample Data*/
/* insert into branch */
INSERT INTO CompanyBranch VALUES
("B01", "New York"),
("B02", "Nashville"),
("B03", "Chicago"),
("B04", "London");

/* insert into department. 01: Human Resource, 02: Finance, 03: Technology, 04: Sales */
INSERT INTO Department VALUES
("D01", "B01", "HumanResource", "nyhr@p.com"),
("D04", "B01", "Sales", "nysales@p.com"),
("D04", "B02", "Sales", "nashsales@p.com"),
("D02", "B02", "Finance", "nashfin@p.com"),
("D01", "B03", "HumanResource", "chihr@p.com"),
("D04", "B03", "Sales", "chisales@p.com"),
("D03", "B03", "Technology", "chitech@p.com"),
("D01", "B04", "HumanResource", "ldhr@p.com"),
("D04", "B04", "Sales", "ldsales@p.com"),
("D02", "B04", "Finance", "ldfin@p.com");

/* insert into position. 01: staff 02: junior 03: senior 04: vice 05: manager */
INSERT INTO Position VALUES
("P01", "D01", "B01", "Staff", 1, 10000, 0),
("P05", "D01", "B01", "Manager", 5, 50000, 0),
("P02", "D04", "B01", "Junior", 2, 20000, 0),
("P03", "D04", "B01", "Senior", 3, 30000, 0),
("P04", "D04", "B01", "Vice", 4, 40000, 1),
("P05", "D04", "B01", "Manager", 5, 50000, 0),
("P02", "D04", "B02", "Junior", 2, 20000, 1),
("P03", "D04", "B02", "Senior", 3, 30000, 1),
("P05", "D04", "B02", "Manager", 5, 50000, 0),
("P01", "D02", "B02", "Staff", 1, 10000, 0),
("P05", "D02", "B02", "Manager", 5, 50000, 1),
("P01", "D01", "B03", "Staff", 1, 10000, 0),
("P05", "D01", "B03", "Manager", 5, 50000, 1),
("P02", "D04", "B03", "Junior", 2, 20000, 1),
("P03", "D04", "B03", "Senior", 3, 30000, 1),
("P05", "D04", "B03", "Manager", 5, 50000, 0),
("P02", "D03", "B03", "Junior", 2, 20000, 1),
("P03", "D03", "B03", "Senior", 3, 30000, 0),
("P05", "D03", "B03", "Manager", 5, 50000, 1),
("P05", "D01", "B04", "Manager", 5, 50000, 0),
("P01", "D01", "B04", "Staff", 1, 10000, 1),
("P03", "D04", "B04", "Senior", 3, 30000, 3),
("P05", "D04", "B04", "Manager", 5, 50000, 1),
("P01", "D02", "B04", "Staff", 1, 10000, 2),
("P05", "D02", "B04", "Manager", 5, 50000, 1);


/* insert into Employee */
INSERT INTO Employee VALUES
("0001", "Lucy", "F", '1980-03-03', 56000, '2014-03-01', 500),
("0002",  "Martin", "M", '1984-03-09', 13000, '2012-05-01', 500),
("0003",  "David", "M", '1987-04-05', 22000, '2006-07-01', 500),
("0004",  "Sam","F", '1978-09-15', 36000, '2001-06-01', 500),
("0005",  "Fisher", "M", '1985-06-22', 53000, '2004-06-01', 500),
/*New York has sa vice available*/
("0006",  "Panda", "M", '1976-04-21', 44000, '1996-06-01', 500),
("0007",  "Prada", "F", '1975-06-30', 58000, '2004-06-01', 500),
("0008",  "Leo", "M", '1981-12-06', 58000, '2013-06-01', 500),
("0009",  "Anna", "F", '1976-05-06', 14000, '1998-09-01', 500),
/*Nashville has sa junior, senior, fi manager available*/
("0010", "Tom", "M", '1972-05-01', 11000, '2002-01-01', 500),
("0011",  "Tim", "M", '1966-05-08', 39000, '1994-02-01', 900),
("0012",  "Bush", "M", '1975-09-09', 13000, '2011-09-01', 500),
("0013",  "Obama", "M", '1985-06-22', 74000, '2011-10-27', 500),
("0014",  "Jack", "M", '1979-08-26', 49000, '2008-05-01', 500),
("0015",  "Nancy", "F", '1989-09-01', 51000, '2002-01-01',  500),
/*Chicago misses HR manager, TE junior manager, SA senior junior*/
("0016", "Beckham", "M", '1977-04-05', 53000, '2017-01-01', 500),
("0020",  "Clinton", "M", '1955-06-22', 17000, '2004-06-01', 500);
/*London has hr manager only*/

/* insert into Former */
INSERT INTO Former VALUES
("0006", '2003-05-17'),
("0007", '2009-06-20'),
("0012", '2017-01-13'),
("0013", '2016-05-02'),
("0020", '2016-08-20');

/* insert into Resign and Fired */
INSERT INTO Resign VALUES
("0007", "F"),
("0020", "G");

INSERT INTO Fired VALUES
("0006", "A"),
("0012", "B"),
("0013", "A");

/* insert into EmploymentHistory */
INSERT INTO EmploymentHistory VALUES
("0001", '2014-03-01',NULL, "P05", "D01", "B01"),
("0002", '2012-05-01',NULL,"P01", "D01", "B01"),
("0003", '2006-07-01', NULL, "P02", "D04", "B01"),
("0004", '2001-06-01',NULL, "P03", "D04",  "B01"),
("0005", '2004-06-01', NULL, "P05", "D04",  "B01"),
("0006", '1996-06-01', '2003-05-17',"P02", "D03", "B03"),
("0007",  '2004-06-01', '2009-06-20',"P05", "D04", "B04" ),
("0008", '2013-06-01', NULL, "P05", "D04",  "B02"),
("0009", '1998-09-01', NULL, "P01",  "D02", "B02"),
("0010", '2002-01-01', NULL, "P01",  "D01",  "B03"),
("0011", '1994-02-01', NULL, "P03", "D03", "B03"),
("0012", '2011-09-01', '2017-01-13', "P01",  "D02", "B04"),
("0013", '2011-10-27', '2016-05-02', "P05", "D02", "B04"),
("0014", '2008-05-01', NULL, "P03",  "D03", "B03"),
("0016", '2017-01-01', NULL, "P05", "D01", "B04"),
("0020", '2004-06-01', '2016-08-20', "P05", "D01", "B04"),
("0015", '2005-05-01', '2008-12-31', "P05", "D01", "B03"),
("0015", '2009-01-01', '2009-12-31', "P05", "D02", "B02"),
("0015", '2010-01-01', NULL, "P05", "D04", "B03");

/*insert into applicant*/
INSERT INTO Applicant VALUES
("AP01", "Bob","M", '1996-01-01'),
("AP02", "Leo", "M", '1981-12-06'),
("AP03", "Lucy", "F", '1980-03-03'),
("AP04", "Bush", "M", '1975-09-09'),
("AP05", "Jerry", "F", '1984-05-09'),
("AP07", "Panda", "M", '1976-04-21');

/*insert into application*/
INSERT INTO Application VALUES
("A01", "AP01", NULL, "P01", "D02", "B04", "TRUE", NULL, '2017-01-01',"ResumeA01"),
("A02", "AP02", "0008", "P05", "D04", "B02", "TRUE", "TRUE", '2013-03-01',"ResumeA02"),
("A03", "AP03", "0001", "P05", "D01", "B01", "TRUE", "TRUE", '2014-01-01',"ResumeA03"),
("A04", "AP04", "0012", "P01", "D02", "B04", "TRUE", "TRUE",'2011-08-07', "ResumeA04"),
("A05", "AP05", NULL, "P01", "D02", "B04", "FALSE", NULL, '2012-03-08', "ResumeA05"),
("A06", "AP01", NULL, "P03", "D04", "B04", "TRUE", NULL, '2017-02-01',"ResumeA06"),
("A07", "AP07", NULL, "P03", "D04", "B04", NULL, NULL, '2017-02-01',"ResumeA07");

/* insert into referral */
INSERT INTO Referral  VALUES
("R01", "A02", "0011", '2013-02-01', "SupportLetter1" ),
("R02", "A03", "0011", '2013-12-01', "SupportLetter2" ),
("R03", "A04", "0011", '2011-08-13', "SupportLetter3" ),
("R04", "A05", "0014", '2012-02-02', "SupportLetter4" );

/* insert into SuccessRef */
INSERT INTO SuccessRef  VALUES
("R01", 500),
("R02", 700),
("R03", 900);

/********************/
/*   create views   */
/********************/
/* View1: Search out all open positions */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE VIEW SearchAvailablePosition AS
SELECT p.PosName, d.DepName, c.City, p.AvailableQ
FROM Position p, Department d, CompanyBranch c
WHERE d.BranchID = c.BranchID 
AND p.BranchID = d.BranchID 
AND p.DepID = d.DepID 
AND AvailableQ >= 1;

/* View2: Shows applicants who have been employed in the past 1 year */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE VIEW NewEmployee1Year AS
SELECT apt.ApplicantID, apt.name, apt.Gender, apt.DOB, apl.PosID, apl.DepID, apl.BranchID
FROM Application apl, Applicant apt, Employee e
WHERE apl.ApplicantID = apt.ApplicantID
	AND e.EmployeeID = apl.EmployeeID
	AND JULIANDAY('now') - JULIANDAY(e.EmployDate) <= 365;

/* View3: Holds all the successful referral information*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
CREATE VIEW SuccessReferralHistory AS
SELECT E1.EmployeeID AS OemployeeID, A.ApplicationID, A. ApplicantID, 
A.EmployeeID AS NemployeeID, R.RefID, E2.EmployDate, A.PosID, A.DepID, A.BranchID, SR.BonusPay
FROM Employee E1, Referral R, Application A,Employee E2, SuccessRef SR
WHERE E1.EmployeeID=R.EmployeeID 
AND  A.ApplicationID=R.ApplicationID 
AND E2.EmployeeID=A.EmployeeID
AND SR.RefID=R.RefID;

/* View4: Shows Employment History of all employees who were employed after 2016/1/1 */
/* Author: Jiayi Yu, Reviewer: Long Wan, Lu Yin */
CREATE VIEW EmploymentHistoryView AS
SELECT Employee.EmployeeID, StartDate, EndDate, Position.PosID, Position.DepID, Position.BranchID
FROM Employee NATURAL JOIN EmploymentHistory NATURAL JOIN Position
WHERE Employee.EmployDate>Date(2016-01-01);

/********************/
/* create triggers  */
/********************/
/* Trigger1: In the application table, if an applicant is admitted and accepts the offer, the applicant information will be automatically inserted into employee table, whose unique employee id is the maximum value of current ids plus 1. The number of available position for the specific PosID the person applied for should be reduced by 1 in Position table. This piece of news should also be added into employment history as a new record, where end date is always null, meaning this employee is working currently at this position. */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER AppToEmp
AFTER UPDATE OF Acceptance ON Application
FOR EACH ROW
WHEN new.Acceptance = "TRUE"
BEGIN
	/* Insert a new row into employee. */
	INSERT INTO Employee
	/* EmplyeeID is allocated automatically by adding 1 to the maximum value of current EmplyeeID */
  SELECT MAX(e.EmployeeID)+1, app.name,app.gender, app.DOB,p.BaseSalary,DATE('now'),500
  FROM Employee e, Application a, Applicant app, Position p
  WHERE ApplicationID = old.ApplicationID 
  AND app.ApplicantID = a.ApplicantID
   AND a.PosID = p.PosID
   AND a.DepID = p.DepID
   AND a.BranchID = p.BranchID;

   /* Update EmployeeID in Applicaiton table */
   UPDATE Application
   SET EmployeeID = 
	(SELECT DISTINCT MAX(EmployeeID)
 	FROM Employee
  WHERE ApplicationID = new.ApplicationID);
	
 /* Add the successful referral information into SuccessRef table */
 INSERT INTO SuccessRef 	
 SELECT RefID, e.BaseBonus
	FROM Referral r, Employee e
	WHERE r.EmployeeID = e.EmployeeID 
		AND r.ApplicationID = old.ApplicationID;

/* After insertion into Employee, the available quantity of a specific position should be reduced by 1 */
	UPDATE Position
	SET AvailableQ = AvailableQ - 1
	WHERE BranchID = old.BranchID
	AND DepID = old.DepID
	AND PosID = old.PosID;

 /* A new record should be added into the employment history */
   INSERT INTO EmploymentHistory
   VALUES( (SELECT MAX(EmployeeID)  
   FROM Employee), 
   DATE('now'), NULL, new.PosID, new.DepID, new.BranchID);
   
   /* All admitted positions other than the accepted one are set false on acceptance for this applicant */
UPDATE Application
SET Acceptance = "FALSE"
WHERE ApplicantID = new.ApplicantID 
	AND IfAdmitted = "TRUE"
	AND Acceptance = NULL;

/* All positions that have not been admitted yet are set false on IfAdmitted for this applicant */
UPDATE Application
SET IfAdmitted = "FALSE"
WHERE ApplicantID = new.ApplicantID 
	AND IfAdmitted = NULL;

END;

/* Trigger2&3&4: If an employee is fired or resigned, add the employee ID into Former table, and add the available quantity of this position by 1 in Position table. But if this person is fired because of downsizing positions, do not change the available quantity for this position. */
/* Trigger 2: Add employee ID into Former table if one is inserted into Resign table. In the meantime, update the available quantity for this position */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER ResignToFormer
BEFORE INSERT ON Resign
FOR EACH ROW
BEGIN
	/* add the employee into Former table */
	INSERT INTO Former
	VALUES(new.EmployeeID, DATE('now'));
/* add the available quantity in Position table */
UPDATE Position
SET AvailableQ = AvailableQ + 1
WHERE BranchID = (
	SELECT BranchID 
	FROM EmploymentHistory
	WHERE EmployeeID = new.EmployeeID) 
AND DepID = (
	SELECT DepID 
	FROM EmploymentHistory
	WHERE EmployeeID = new.EmployeeID)
AND PosID = (
	SELECT DepID 
	FROM EmploymentHistory 
	WHERE EmployeeID = new.EmployeeID);

UPDATE EmploymentHistory
SET EndDate = DATE('now')
WHERE EmployeeID = new.EmployeeID AND EndDate IS NULL;
END;

/* Trigger 3: Add employee ID into Former table if one is inserted into Fired table */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER FiredToFormer
BEFORE INSERT ON Fired
FOR EACH ROW
BEGIN
	/* add the employee ID into Former table */
	INSERT INTO Former
	VALUES(new.EmployeeID, DATE('now'));

	/* Set the employee’s end date the current date */
UPDATE EmploymentHistory
SET EndDate = DATE('now')
WHERE EmployeeID = new.EmployeeID AND EndDate IS NULL;
END;

/* Trigger 4: Add the available quantity by 1 if a person is fired because of reasons of non-downsizing positions. */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER FiredForNonDownsizing
BEFORE INSERT ON Fired
FOR EACH ROW
WHEN new.FiredReason <> "A" /* suppose reason A represents downsizing positions */
BEGIN
UPDATE Position
SET AvailableQ = AvailableQ + 1
WHERE BranchID = (
	SELECT BranchID 
	FROM EmploymentHistory EH
	WHERE  EH.EmployeeID = new.EmployeeID) 
AND DepID = (
	SELECT DepID 
	FROM EmploymentHistory EH
	WHERE EH.EmployeeID = new.EmployeeID)
AND PosID = (
	SELECT DepID 
	FROM EmploymentHistory EH
	WHERE EH.EmployeeID = new.EmployeeID);
END;

/* Trigger 5: If an employee successfully made a referral and the referee became an formal employer, add the base bonus of this employee by 200*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
CREATE TRIGGER NewReferreeAcceptance
AFTER INSERT ON SuccessRef
BEGIN
UPDATE Employee 
SET BaseBonus=BaseBonus+200
WHERE EmployeeID IN (
SELECT e.EmployeeID 
	FROM Employee e,  Referral R
	WHERE new.RefID=R.RefID 
		AND R.EmployeeID=e.EmployeeID);
END;

/* Trigger 6: If an employee quits the job within 1 year since its employment date, decease his/her referrer's base bonus by 400*/
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER ReferreeBecomeFormer1Year
AFTER INSERT ON Former
/*WHEN new.employeeID in (SELECT a.EmployeeID from application a, referral where a.applicationID=r.applicationID)*/
BEGIN
	UPDATE Employee
	SET BaseBonus = BaseBonus - 400
	WHERE EmployeeID IN(
		SELECT e.EmployeeID
		FROM Employee e, Referral r, Application App
		WHERE e.EmployeeID = r.EmployeeID 
			AND App.ApplicationID=r.ApplicationID
AND App.EmployeeID=new.EmployeeID
			AND (JULIANDAY(new.DimDate) - JULIANDAY(
				(SELECT EmployDate
				FROM Employee NATURAL JOIN Former 
				WHERE Employee.EmployeeID = new.EmployeeID)))
<365);
END;

/* Trigger 7: If a current employee is promoted to a new position, create a new record in EmploymentHistory table and update the end date for this person's previous record. Plus, add the available quantity of this position the person leaves by 1. */
/* Author: JiayiYu Reviewer: Lu Yin, Long Wan */
CREATE TRIGGER PositionUpdate
BEFORE INSERT ON EmploymentHistory
FOR EACH ROW
BEGIN
	/* update available quantity for old position */
	UPDATE Position
	SET AvailableQ = AvailableQ+1
	WHERE PosID = (SELECT PosID 
FROM EmploymentHistory eh
WHERE eh.EmployeeID = new.EmployeeID 
AND eh.EndDate IS NULL) 
AND DepID = (SELECT DepID 
FROM EmploymentHistory eh
WHERE eh.EmployeeID = new.EmployeeID 
AND eh.EndDate IS NULL)
AND BranchID = (SELECT BranchID 
FROM EmploymentHistory eh
WHERE eh.EmployeeID = new.EmployeeID 
AND eh.EndDate IS NULL);

	/* set end date to current date for this person at this position */
	UPDATE EmploymentHistory
	SET EndDate = DATE('now')
	WHERE EmployeeID = new.EmployeeID
		AND EndDate IS NULL;

	/* update salary to the new base salary */
	UPDATE Employee
	SET Salary= (SELECT BaseSalary  FROM Position
 WHERE Position.PosID=new.PosID
		AND Position.DepID=new.DepID
		AND Position.BranchID=new.BranchID)
WHERE Employee.EmployeeID=new.EmployeeID;
END;
	
/* Trigger 8: After insertion into Former table, update the employment history and set the end date of this employee the current date.  */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER FormerToHistory
AFTER INSERT ON Former
FOR EACH ROW
BEGIN
	UPDATE EmploymentHistory
	SET EndDate = DATE('now')
	WHERE EmployeeID = new.EmployeeID 
		AND EndDate IS NULL;
END;

/* Trigger9: When updating the available quantity in SearchAvailablePosition view, do the same thing for base tables. */
/* Author: Long Wan Reviewer: Lu Yin, Jiayi Yu */
CREATE TRIGGER AvailablePositionChange
INSTEAD OF UPDATE ON SearchAvailablePosition
FOR EACH ROW
BEGIN
	UPDATE Position
	SET AvailableQ = new.AvailableQ
	WHERE BranchID = (
SELECT DISTINCT(BranchID)
FROM CompanyBranch
WHERE City = new.City)
AND DepID = (
SELECT DISTINCT(DepID)
FROM Department
WHERE DepName = new.DepName)
AND PosID = (
SELECT DISTINCT(PosID)
FROM Position
WHERE PosName = new.PosName);
END;

/********************/
/*     queries      */
/********************/
/* 1. The most frequent dismissal reason*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT Reason, num
FROM(SELECT ResignReason AS Reason, COUNT(*) AS num 
 FROM Resign
           GROUP BY Reason
 UNION
 SELECT FiredReason AS Reason, COUNT(*) AS num FROM Fired
           GROUP BY Reason)
ORDER BY num DESC
LIMIT 1;
 
/*2. Calculate each dismissal rate of each branch after 2016/1/1. If no one dismiss from one branch during this period, this branch will not show in the final result.*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT (cast (dimnum as double) / cast ((empnum+dimnum) as double)) AS DismissalRate, temp1. BranchID
FROM (SELECT COUNT (E.EmployeeID) AS dimnum, Position.BranchID AS BranchID
             FROM Former, Employee E, EmploymentHistory EH NATURAL JOIN Position
             WHERE Former.EmployeeID=E.EmployeeID
AND JULIANDAY(DimDate)-JULIANDAY('2016-01-01')>0 
AND E.EmployeeID=EH.EmployeeID
             GROUP BY EH.BranchID)   temp1,
             (SELECT COUNT(E.EmployeeID) AS empnum, Position.BranchID AS BranchID
              FROM (Employee E NATURAL JOIN EmploymentHistory EH) 
NATURAL JOIN Position
	     WHERE EH.EndDate IS NULL    
              GROUP BY EH.BranchID)  temp2
WHERE temp2.BranchID=temp1.BranchID
ORDER BY DismissalRate DESC;

/* 3. Find the position with highest application/available quantity. */
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT PosID, DepID, BranchID, (applynum/AvailableQ) rate
FROM(SELECT PosID, DepID, BranchID, COUNT(*) AS applynum
 FROM Application
   GROUP BY PosID, DepID, BranchID)
   NATURAL JOIN
  (SELECT PosID, DepID, BranchID, AvailableQ
   FROM Position
   WHERE AvailableQ > 0)
ORDER BY rate DESC
LIMIT 1;
 
/*4. For each employee who has successfully referred at least 3 applicants who accepted an offer, find the dismissal rate of these applicants */
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT (CAST(dimnum AS DOUBLE)/ CAST(refnum AS DOUBLE)) AS ratio, Temp1.OemployeeID
FROM( SELECT COUNT(NemployeeID) AS dimnum,OemployeeID
  FROM SuccessReferralHistory SRH, Former F
  WHERE SRH.NemployeeID=F.employeeID
  GROUP BY OemployeeID) Temp1,
(SELECT COUNT(NemployeeID) AS refnum, OemployeeID
FROM SuccessReferralHistory SRH
GROUP BY OemployeeID
HAVING refnum >=3) Temp2
WHERE Temp1.OemployeeID=Temp2. OemployeeID;
 
/* 5. Calculate bonus per applicant who got referrals before and was employed after 2003/1/1  for each branch*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT (totalpay /employnum) AS ratio, temp1.BranchID
FROM ( SELECT SUM (SRH.BonusPay) AS totalpay, EH.BranchID AS BranchID
   FROM SuccessReferralHistory SRH, 
(Employee E NATURAL JOIN EmploymentHistory EH) 
NATURAL JOIN Position
   WHERE   JULIANDAY(E.EmployDate)-JULIANDAY('2003-01-01')
   	AND  SRH.NemployeeID=E.EmployeeID
    GROUP BY EH.BranchID) temp1,
    (SELECT COUNT (E.EmployeeID) AS employnum, EH.BranchID AS BranchID
    FROM (Employee E NATURAL JOIN EmploymentHistory EH) 
    NATURAL JOIN Position,SuccessReferralHistory SRH
    WHERE JULIANDAY(E.EmployDate)-JULIANDAY('2003-01-01')>0
   AND  SRH.NemployeeID=E. EmployeeID
GROUP BY EH.BranchID) temp2
WHERE temp1.BranchID=temp2.BranchID
ORDER BY ratio DESC;

/* 6. Find employees that all candidates they referred are hired. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT Temp1.EmployeeID
FROM (
(SELECT R.EmployeeID, COUNT (DISTINCT Ap.ApplicantID) AS referralNum
FROM Referral R, Application A, Applicant Ap
WHERE R.ApplicationID=A.ApplicationID 
   AND Ap.ApplicantID=A.ApplicantID
GROUP BY R.EmployeeID) Temp1,
(SELECT R.EmployeeID, COUNT (DISTINCT Ap.ApplicantID) AS hiredNum
FROM Referral R, Application A, Applicant Ap
WHERE R.ApplicationID=A.ApplicationID 
  AND AP.ApplicantID=A.ApplicantID 
  AND A.Acceptance="TRUE"
GROUP BY R.EmployeeID) Temp2
)
WHERE Temp1.EmployeeID=Temp2.EmployeeID 
AND referralNum = hiredNum;

/* 7. Find all current employees that were hired before year 2000. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT Employee.EmployeeID, Name, EmployDate
FROM (
	SELECT EmployeeID FROM Employee
	EXCEPT
	SELECT EmployeeID FROM Former
) CurrentEmployee NATURAL JOIN Employee
WHERE EmployDate< DATE ('2000-01-01');

/* 8. Find all branches that have more than 3 employees. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT BranchID, COUNT (*) AS EmployeeCount
FROM ((
	SELECT EmployeeID FROM Employee
	EXCEPT
	SELECT EmployeeID FROM Former
) CurrentEmployee NATURAL JOIN EmploymentHistory)
NATURAL JOIN Position
WHERE EmploymentHistory.EndDate IS NULL
GROUP BY Position.BranchID
HAVING COUNT (*) >3;

/* 9. For each employee who has referral history, find his/her referral success rate and
the total number of applicants he/she has referred. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT t1.EmployeeID, t1.successCount/t2.totalCount AS successRate, 
    t2.totalCount
FROM (
(SELECT Employee.EmployeeID, COUNT (DISTINCT ApplicantID) AS successCount
FROM ((Employee NATURAL JOIN Referral) 
JOIN Application USING (ApplicationID))
JOIN Applicant USING (ApplicantID)
WHERE Acceptance="TRUE"
GROUP BY Employee.EmployeeID) t1
NATURAL JOIN
(SELECT Employee.EmployeeID, COUNT (DISTINCT ApplicantID) AS totalCount
FROM ((Employee NATURAL JOIN Referral) 
JOIN Application USING (ApplicationID))
JOIN Applicant USING (ApplicantID)
GROUP BY Employee.EmployeeID) t2
);

/* 10. Find which branch has the highest referral success rate. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT t1.BranchID, cast(successCount as double) / cast(totalCount as double) AS SuccessRate
FROM (
(SELECT EmploymentHistory.BranchID, COUNT (DISTINCT ApplicantID) AS successCount
FROM (((Employee NATURAL JOIN Referral) 
	NATURAL JOIN EmploymentHistory) 
JOIN Application USING (ApplicationID))
JOIN Applicant USING (ApplicantID)
WHERE Acceptance="TRUE" and EmploymentHistory.EndDate IS NULL
GROUP BY EmploymentHistory.BranchID) t1
NATURAL JOIN
(SELECT EmploymentHistory.BranchID, COUNT (DISTINCT ApplicantID) AS totalCount
FROM (((Employee NATURAL JOIN Referral) 
NATURAL JOIN EmploymentHistory) 
JOIN Application USING (ApplicationID))
JOIN Applicant USING (ApplicantID)
WHERE EmploymentHistory.EndDate IS NULL
GROUP BY EmploymentHistory.BranchID) t2
)
ORDER BY SuccessRate DESC;

/*11.Show the applicant who has already been admitted by the company but haven"t give any response*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT DISTINCT Ap. ApplicantID, Ap.name
FROM Application A, Applicant Ap
WHERE Ap.applicantID=A.applicantID AND A.IfAdmitted="TRUE" 
AND Acceptance IS NULL;

/* 12. Find ratio of female referees among all referees referred by male employees for each branch */
/* Author: Long Wan  Reviewer: Jiayi Yu, Lu Yin */
SELECT (CAST(temp2.num2 AS DOUBLE)/CAST(temp1.num1 AS DOUBLE)) AS FemaleRatioByMale, temp1.BranchID
FROM (SELECT COUNT(*) AS num1, p.BranchID
FROM (Employee NATURAL JOIN EmploymentHistory) p, Referral r, Application app, 
Applicant apl
WHERE p.EmployeeID = r.EmployeeID AND r.ApplicationID = app.ApplicationID
AND app.ApplicantID = apl.ApplicantID
AND p.Gender = "M" AND p.EndDate IS NULL
GROUP BY p.BranchID) temp1,
(SELECT COUNT(*) AS num2, p.BranchID
FROM (Employee NATURAL JOIN EmploymentHistory) p, Referral r, Application app, Applicant apl
WHERE p.EmployeeID = r.EmployeeID AND r.ApplicationID = app.ApplicationID
AND app.ApplicantID = apl.ApplicantID 
AND p.Gender = "M" AND apl.Gender = "F" 
AND p.EndDate IS NULL
GROUP BY p.BranchID) temp2
WHERE temp1.BranchID = temp2.BranchID;

/*13.The male/female ratio of each branch. If there is no female employee in one branch, this branch will not show in the final result*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT (CAST (male AS DOUBLE)/CAST (female AS DOUBLE)) AS ratio, temp1.BranchID
FROM (SELECT COUNT(*) AS male, EmploymentHistory.BranchID AS BranchID
	FROM (Employee NATURAL JOIN EmploymentHistory) 
NATURAL JOIN Position
	WHERE Gender="M" AND EmploymentHistory. EndDate IS NULL
	GROUP BY EmploymentHistory.BranchID) temp1,
(SELECT COUNT(*) AS female, EmploymentHistory.BranchID AS BranchID
	FROM (Employee NATURAL JOIN EmploymentHistory) 
NATURAL JOIN Position
	WHERE Gender="F" 
AND EmploymentHistory. EndDate IS NULL
	GROUP BY EmploymentHistory.BranchID) temp2
WHERE temp1.BranchID=temp2.BranchID;


/* 14.Find top 2 current employees who won the greatest amount of bonus for successful referrals as well as the person's branch, the number of successful referrals*/
/* Author: Long Wan  Reviewer: Jiayi Yu, Lu Yin */
SELECT SUM(s.BonusPay) AS TotalBonus, e.EmployeeID, COUNT(*) AS RefNum, eh.BranchID
FROM SuccessRef s, Referral r, Employee e, EmploymentHistory eh
WHERE s.RefID = r.RefID 
AND r.EmployeeID = e.EmployeeID 
AND eh.EmployeeID = e.EmployeeID 
AND eh.EndDate IS NULL
GROUP BY e.EmployeeID
ORDER BY TotalBonus DESC
LIMIT 1;

/*15.Find current employees with the highest base bonus but have been in this company for at least 3 years */
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT EmployeeID
FROM Employee
WHERE EmployeeID NOT IN (SELECT EmployeeID
FROM Former) 
AND EmployeeID IN (SELECT EmployeeID 
FROM Employee 
ORDER BY basebonus DESC 
LIMIT 1)
	AND JULIANDAY(Employdate) + 365 * 3 < JULIANDAY('now');

/*16.Find the reason why the former employee leave the company, order by their basebonus*/
/*Author: Lu Yin  Reviewer: Long Wan, Jiayi Yu*/
SELECT EmployeeID, Reason
FROM ( SELECT EmployeeID, FiredReason AS Reason 
	  FROM Fired
	  UNION
  SELECT EmployeeID, ResignReason AS Reason 
  FROM Resign)
WHERE EmployeeID IN (SELECT E.EmployeeID 
FROM Employee E, Former F
WHERE E.EmployeeID= F.EmployeeID
ORDER BY basebonus DESC);

/* 17.Find all employees with more than two employment histories */
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT EmployeeID, COUNT(*) AS historyCount
FROM EmploymentHistory
GROUP BY EmployeeID
HAVING COUNT(*) >2;

/* 18.Calculate average difference between managers' salary and base salary for each branch*/
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT Position.BranchID, AVG(Salary-BaseSalary)
FROM ((
(SELECT EmployeeID
	FROM Employee
	EXCEPT
	SELECT EmployeeID
	FROM Former
) currentEmployee 
NATURAL JOIN Employee)
JOIN EmploymentHistory USING (EmployeeID))
JOIN Position USING (PosID, DepID, BranchID)
WHERE PosName= "Manager" 
AND EmploymentHistory.EndDate IS NULL
GROUP BY Position.BranchID ;

/* 19.Find all applicantion history for each employee*/
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT Employee.EmployeeID, Application.ApplicationID, IfAdmitted, Acceptance, Resume, ApplyDate, Application.PosID, Application.DepID, Application.BranchID
FROM((SELECT EmployeeID, ApplicantID
FROM Application
WHERE Acceptance="TRUE"
)temp1 JOIN Application USING (ApplicantID)) 
JOIN Employee USING (EmployeeID)
WHERE ApplyDate<EmployDate;

/* 20.Find all applicants that were used to be an employee and dismissed. We assume that there doesn’t exist two persons who have same name gender and date of birth*/
/* Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin */
SELECT temp1.ApplicantID, temp1.Name, temp1.Gender, temp1.DOB
FROM(SELECT Name, Gender, DOB, ApplyDate, ApplicantID
FROM Application JOIN Applicant USING (ApplicantID)
WHERE IfAdmitted IS NULL
) temp1,
	(SELECT Name, Gender, DOB,DimDate
FROM Former JOIN Employee USING (EmployeeID)
) temp2
WHERE temp1.Name=temp2.Name 
AND temp1.Gender= temp2.Gender 
AND temp1.DOB=temp2.DOB 
AND JULIANDAY(temp1.ApplyDate)-JULIANDAY(temp2.DimDate)>0;

/********************/
/*    operations    */
/********************/
/* The following operations are done for checking triggers */
/*a. update the application to admit one person to demonstrate trigger 1 & 7. The person newly admitted gets a new employee ID and is inserted into Employee table as well as EmployementHistory table. Also, the available quantity for the position the person applied is reduced by 1*/
UPDATE Application SET Acceptance= "TRUE" WHERE ApplicationID="A01";

/* b. Demo triggers 2&3&4. The two persons are added into the Former table automatically. Since the person “0002” is fired because of A(down sizing), the available quantity of his/her position is not changed. Plus, EmploymentHistory for them is also changed. */
INSERT INTO Resign VALUES("0001", "F");
INSERT INTO Fired VALUES("0002", "A");

/* c. Demo triggers 5. A applicant is admitted and accepts the offer, so the referral succeed. The applicant is added into Employee table as well as employment history table. A new record is added into SuccessRef table, and the employee who referred “A05” gets referral bonus, and his/her base bonus is added by 200. */
UPDATE Application SET IfAdmitted = "TRUE" WHERE ApplicationID="A05";
UPDATE Application SET Acceptance = "TRUE" WHERE ApplicationID="A05";

/*d. Demo triggger 3&6&8. Since Applicant “A05” quits the job within one year since employement, the employee “0014” who referred him, is deducted by 400 on its base bonus.*/
INSERT INTO Fired VALUES("22", "B");

/*e. Demo triggger 3&6&8. Positions of employees at this branch are set null */
DELETE FROM CompanyBranch WHERE BranchID = "B02"; 

/********************/
/*   drop tables    */
/********************/
/* Delete the tables, triggers and views if they already exist. */
DROP TABLE IF EXISTS EmploymentHistory;
DROP TABLE IF EXISTS Fired;
DROP TABLE IF EXISTS Resign;
DROP TABLE IF EXISTS Former;
DROP TABLE IF EXISTS SuccessRef;
DROP TABLE IF EXISTS Referral;
DROP TABLE IF EXISTS Application;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Applicant;
DROP TABLE IF EXISTS Position;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS CompanyBranch;
DROP VIEW IF EXISTS  SearchAvailablePosition;
DROP VIEW IF EXISTS  NewEmployee1Year;
DROP VIEW IF EXISTS  SuccessReferralHistory;
DROP VIEW IF EXISTS EmploymentHistoryView;
DROP TRIGGER IF EXISTS AppToEmp;
DROP TRIGGER IF EXISTS ResignToFormer;
DROP TRIGGER IF EXISTS FiredToFormer;
DROP TRIGGER IF EXISTS FiredForNonDownsizing;
DROP TRIGGER IF EXISTS NewReferreeAcceptance;
DROP TRIGGER IF EXISTS ReferreeBecomeFormer1Year;
DROP TRIGGER IF EXISTS PositionUpdate;
DROP TRIGGER IF EXISTS FormerToHistory;
DROP TRIGGER IF EXISTS AvailablePositionChange;