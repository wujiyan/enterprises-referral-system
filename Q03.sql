SELECT PosID, DepID, BranchID, (applynum/hirenum) rate
FROM(SELECT PosID, DepID, BranchID, count(*) AS applynum
 FROM Application
   GROUP BY PosID, DepID, BranchID)
   NATURAL JOIN
  (SELECT PosID, DepID, BranchID, count(*) AS hirenum
   FROM Position
   WHERE AvailableQ > 0
   GROUP BY PosID, DepID, BranchID)
ORDER BY rate DESC
LIMIT 1
