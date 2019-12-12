
set system parameters 'return_null_on_function_errors=yes';
create table t (s varchar, c char(1), i bigint);
insert into t values
	('a', 'b', 97),
	('b', 'a', 97),
	('x', 'y', 120),
	('y', 'x', 120),
	('FF', 'x', 10),
	('7A', 'z', 10);

-- hex tests
create index idx on t (s, c, i) where (hex(s) = conv(i, 10, 16));
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where (hex(s) = '61') or (hex(c) = '61') rebuild;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where hex(s) rebuild;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where hex(s) = rand() rebuild;
drop index idx on t;

-- ASCII tests
create index idx on t (s, c, i) where ascii(s) = 120;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where (ascii(s) = i) or (ascii(c) = i) rebuild;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where ascii(s) rebuild;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where ascii(s) = now() rebuild;
drop index idx on t;

-- CONV tests
create index idx on t (s, c, i) where conv(s, 16, 10) = '255';
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where conv(s, 10, 16) rebuild;
select * from t where s < 'z' using index idx(+);

alter index idx on t (s, c, i) where ascii(s) = rand() * now() rebuild;
drop index idx on t;

drop table t;
set system parameters 'return_null_on_function_errors=no';
