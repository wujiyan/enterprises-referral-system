/*13.The male/female ratio of each branch*/
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT (male/female) AS ratio,temp1.BranchID
FROM (SELECT COUNT(*) AS male, EmploymentHistory.BranchID AS BranchID
	FROM (Employee NATURAL JOIN EmploymentHistory) NATURAL JOIN Position
	WHERE Gender="M" AND EmploymentHistory. EndDate IS NULL
	GROUP BY EmploymentHistory.BranchID) temp1,
(SELECT COUNT(*) AS female, EmploymentHistory.BranchID AS BranchID
	FROM (Employee NATURAL JOIN EmploymentHistory) NATURAL JOIN Position
	WHERE Gender="F" AND EmploymentHistory. EndDate IS NULL
	GROUP BY EmploymentHistory.BranchID) temp2
WHERE temp1.BranchID=temp2.BranchID;
