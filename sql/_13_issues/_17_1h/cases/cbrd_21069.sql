set system parameters 'CTE_MAX_RECURSIONS=1';
set system parameters 'CTE_MAX_RECURSIONS=2';
set system parameters 'CTE_MAX_RECURSIONS=600';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=700';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=2000';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=1000000';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=1000001';
set system parameters 'CTE_MAX_RECURSIONS=2000000';
