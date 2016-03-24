--Test decode function with date type
create class t1 (a integer, b varchar(20), c date);

insert into t1 values(999, 'nhn', DATE '05/09/2008');
insert into t1 values(888, 'nhnChina', DATE '05/10/2008');
insert into t1 values(777, 'nhnKorea', DATE '05/8/2008');
insert into t1 values(666, 'nhnJapan', DATE '05/7/2008');

select decode(c, DATE '05/09/2008', 'Seoul',
		DATE '05/10/2008', 'BeiJing',
		DATE '05/8/2008', 'Seoul',
		DATE '05/7/2008', 'Tokyo', 'Unknow city') as city, c
from t1 order by 1, 2;
                 
drop class t1;                 
