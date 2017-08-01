/* 5. Calculate bonus per applicant who got referrals before and was employed after 2003/1/1  for each branch*/
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT (totalpay/employnum) AS ratio, temp1.BranchID
FROM ( SELECT SUM (SRH.BonusPay) AS totalpay, EH.BranchID AS BranchID
   FROM SuccessReferralHistory SRH, 
(Employee E NATURAL JOIN EmploymentHistory EH) 
NATURAL JOIN Position
   WHERE   JULIANDAY(E.EmployDate)-JULIANDAY('2003-01-01')
   	AND  SRH.NemployeeID=E.EmployeeID
	AND EH.EndDate IS NULL
GROUP BY EH.BranchID) temp1,

(SELECT COUNT (E.EmployeeID) AS employnum,
EH.BranchID AS BranchID
FROM (Employee E NATURAL JOIN EmploymentHistory EH) 
NATURAL JOIN Position,SuccessReferralHistory SRH
WHERE JULIANDAY(E.EmployDate)-JULIANDAY('2003-01-01')>0
AND  SRH.NemployeeID=E. EmployeeID
AND EH.EndDate IS NULL
GROUP BY EH.BranchID) temp2
WHERE temp1.BranchID=temp2.BranchID
ORDER BY ratio DESC;
