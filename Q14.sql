/* 14.Find top 2 current employees who won the greatest amount of bonus for successful referrals as well as the person’s branch, the number of successful referrals*/
/* Author: Long Wan  Reviewer: Jiayi Yu, Lu Yin */
SELECT SUM(s.BonusPay) AS TotalBonus, e.EmployeeID, count(*) AS RefNum, eh.BranchID
FROM SuccessRef s, Referral r, Employee e, EmploymentHistory eh
WHERE s.RefID = r.RefID AND r.EmployeeID = e.EmployeeID AND eh.EmployeeID = e.EmployeeID AND eh.EndDate IS NULL
GROUP BY e.EmployeeID
ORDER BY TotalBonus DESC
LIMIT 1;
