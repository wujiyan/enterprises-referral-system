/*16.Find the reason why the former employee with top 3 base bonus leave the company*/
/*Author: LU YIN  Reviewer: Long Wan, Jiayi Yu*/
SELECT EmployeeID, Reason
FROM ( SELECT EmployeeID, FiredReason AS Reason 
	  FROM Fired
	  UNION
 SELECT EmployeeID, ResignReason AS Reason 
  FROM Resign)
WHERE EmployeeID IN (SELECT E.EmployeeID 
FROM Employee E, Former F
WHERE E.EmployeeID=F.EmployeeID
ORDER BY basebonus DESC);
