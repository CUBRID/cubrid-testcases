autocommit off;
select t1, t2
from   table ({1,2,3}) as tbl(t1, t2);
rollback;
