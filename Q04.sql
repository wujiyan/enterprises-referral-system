/*4. For each employee who has successfully referred at least 3 applicants who accepted an offer, find the dismissal rate of these applicants */
SELECT (cast(dimnum as double)/ cast(refnum as double)) AS ratio, Temp1.OemployeeID
FROM  (SELECT COUNT(NemployeeID) AS dimnum,OemployeeID
FROM SuccessReferralHistory SRH, Former F
WHERE SRH.NemployeeID=F.employeeID
GROUP BY OemployeeID) Temp1,
(SELECT COUNT(NemployeeID) AS refnum, OemployeeID
FROM SuccessReferralHistory SRH
GROUP BY OemployeeID
HAVING refnum >=3) Temp2
WHERE Temp1.OemployeeID=Temp2. OemployeeID