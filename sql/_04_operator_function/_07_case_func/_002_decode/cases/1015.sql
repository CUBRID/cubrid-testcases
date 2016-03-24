--Test decode function with repeat the same value
create class t1 (
	a char(8), 
	b string, 
	c varchar
);

insert into t1 values('aaa1', 'nhn', 'ccc1');
insert into t1 values('aaa2', 'nhnChina', 'ccc2');
insert into t1 values('aaa3', 'nhnKorea', 'ccc3');
insert into t1 values('aaa4', 'nhnJapan', 'ccc4');

select decode(c, 'ccc1', 'Seoul',
		'ccc1', 'BeiJing',
		'ccc3', 'Seoul',
		'ccc4', 'Tokyo', 'Unknow city') as city, c
from t1 order by 1, 2;

drop class t1;
