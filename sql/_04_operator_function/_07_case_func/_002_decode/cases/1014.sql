--Test decode function with nchar type
create class t1 (
	a bit(8), 
	b nchar(8), 
	c set
);

insert into t1 values(b'00010101', n'nhn', {1,2});
insert into t1 values(b'00010111', n'nhnChina', {3,4});
insert into t1 values(b'00110101', n'nhnKorea', {5,6});
insert into t1 values(b'10010101', n'nhnJapan', {7,8});

select decode(c, {1,2}, 'Seoul',
		{3,4}, 'BeiJing',
		{5,6}, 'Seoul',
		{7,8}, 'Tokyo', 'Unknow city') as city, c
from t1 order by 1, 2;

drop class t1;
