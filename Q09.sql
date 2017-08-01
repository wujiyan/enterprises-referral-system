/* 9. For each employee who has referral history, find his/her referral success rate and
the total number of applicants he/she has referred. */
/*Author: Jiayi Yu  Reviewer: Long Wan, Lu Yin*/
SELECT t1.EmployeeID, t1.successCount/t2.totalCount AS successRate, t2.totalCount
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
JOIN Applicant USING(ApplicantID)
GROUP BY Employee.EmployeeID) t2
);