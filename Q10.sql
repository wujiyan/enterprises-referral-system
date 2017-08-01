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
