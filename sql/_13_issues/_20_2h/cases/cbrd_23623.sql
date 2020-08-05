select CAST('30' AS NUMERIC(38, 0)) - CAST(1 AS NUMERIC(10,1)),
round(cast (1 as int),3)
from db_root;

select CAST('30' AS NUMERIC(38, 0)) - 1.0,
round(cast (1 as int),3)
from db_root;

select  CAST(1 AS NUMERIC(10,1)) - CAST('30' AS NUMERIC(38, 0)),
round(cast (1 as int),3)
from db_root;

select round(cast (1 as int),3),
CAST('30' AS NUMERIC(38, 0)) - CAST(1 AS NUMERIC(10,1))
from db_root;

select round(cast (1 as int),3),
CAST('30' AS NUMERIC(38, 0)) - 1.0
from db_root;

select round(cast (1 as int),3),
CAST(1 AS NUMERIC(10,1)) - CAST('30' AS NUMERIC(38, 0))
from db_root;
