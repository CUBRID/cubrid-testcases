autocommit off;
select cast(2.145 as float)
from class db_user;
select cast(2.145 as numeric(5,2))
from class db_user;
select cast({2.145} as set(float))
from class db_user;
select cast(sequence{2.145} as sequence(numeric(5,2)))
from class db_user;
select cast({2.145, 'i am a string'} as multiset(numeric(5,2), char(14)))
from class db_user;
select cast (NULL as int)
from class db_user;
rollback;
