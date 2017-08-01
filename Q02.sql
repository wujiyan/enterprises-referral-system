/*2. Calculate each dismissal rate of each branch after 2016/1/1*/
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT (cast (dimnum as double) / cast ((empnum+dimnum) as double)) AS DismissalRate, temp1. BranchID

FROM (SELECT COUNT (DISTINCT E.EmployeeID) AS dimnum, 
Position.BranchID AS BranchID
             FROM Former, Employee E, EmploymentHistory EH NATURAL JOIN Position
             WHERE Former.EmployeeID=E.EmployeeID
          	               AND JULIANDAY(DimDate)-JULIANDAY('2016-01-01')>0
			    AND E.EmployeeID=EH.EmployeeID
             GROUP BY EH.BranchID)   temp1,

             (SELECT COUNT(DISTINCT E.EmployeeID) AS empnum, 
Position.BranchID AS BranchID
              FROM (Employee E NATURAL JOIN EmploymentHistory EH) 
NATURAL JOIN Position
	     WHERE EH.EndDate IS NULL    
              GROUP BY EH.BranchID)  temp2
WHERE temp2.BranchID=temp1.BranchID
ORDER BY DismissalRate DESC;
