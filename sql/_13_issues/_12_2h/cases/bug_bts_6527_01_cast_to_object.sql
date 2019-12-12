create table t (
	i int,
	bi bigint,
	f float,
	d double,
	sm smallint,
	m monetary,
	n numeric(10,4),
	da date, 
	dt datetime,
	ti time,
	ts timestamp,
	c char(10),
	vc varchar(10),
	nc nchar(10),
	nvc nchar varying (10),
	b bit(10),
	vb bit varying(10),
	s set of int,
	ms multiset of int,
	se sequence of int);

insert into t values (
	123,
	123,
	123.45,
	123.456,
	123,
	123.45,
	123.4567,
	now(),
	now(),
	now(),
	now(),
	'fox',
	'fox',
	N'fox',
	N'fox',
	X'8',
	X'8',
	{1, 2, 3},
	{1,2, 3, 3, 4},
	{1, 2, 3, 4, 5});

select cast (i as object) from t;
select cast (bi as object) from t;
select cast (f as object) from t;
select cast (d as object) from t;
select cast (sm as object) from t;
select cast (m as object) from t;
select cast (n as object) from t;

select cast (da as object) from t;
select cast (dt as object) from t;
select cast (ti as object) from t;
select cast (ts as object) from t;

select cast (c as object) from t;
select cast (vc as object) from t;
select cast (nc as object) from t;
select cast (nvc as object) from t;

select cast (b as object) from t;
select cast (vb as object) from t;

select cast (s as object) from t;
select cast (ms as object) from t;
select cast (se as object) from t;

select cast (cast (i as object) as varchar) from t;
select cast (cast (i as varchar) as object) from t;
select cast (cast (cast (i as object) as varchar) as object) from t;

drop table t;
