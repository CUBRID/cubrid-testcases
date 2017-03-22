set system parameters 'CTE_MAX_RECURSIONS=1';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<=1
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number>1
)
SELECT Number
FROM MyCTE;

set system parameters 'CTE_MAX_RECURSIONS=2';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<2
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number>2
)
SELECT Number
FROM MyCTE;


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

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<600
)
SELECT Number
FROM MyCTE order by 1 desc limit 5;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number>600
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

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<700
)
SELECT Number
FROM MyCTE order by 1 desc limit 5;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number<800
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

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<2000
)
SELECT Number
FROM MyCTE order by 1 desc limit 10;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number<3000
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

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<1000000
)
SELECT Number
FROM MyCTE order by 1 desc limit 1;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number>1000000
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=1000001';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<1000001
)
SELECT Number
FROM MyCTE order by 1 limit 1;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number>1000001
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=2000000';
WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R
)
SELECT Number
FROM MyCTE;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1
FROM MyCTE AS R where R.Number<2000000
)
SELECT Number
FROM MyCTE order by 1 limit 1;

WITH MyCTE(Number) AS
(
SELECT 1 AS Number
UNION ALL
SELECT R.Number + 1

FROM MyCTE AS R where R.Number>2000000
)
SELECT Number
FROM MyCTE;
set system parameters 'CTE_MAX_RECURSIONS=DEFAULT';
