autocommit off;
select t
from   table ({1, 'str'}) as tbl(t);
rollback;
