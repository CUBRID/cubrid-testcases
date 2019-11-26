--+ holdcas on;
-- create a class with udt to set and insert data to this calss.

create class t1(
id int not null,
a multiset(varchar(10)),
b set(varchar(10)),
c sequence varchar(10));

create class t2(
a set of t1,
b set(varchar(10)),
c sequence varchar(10));


insert INTO t1 values  (1,{'aaa'},{'bbb'},{'ccc'});

SELECT t1 into x from t1 where id=1;

insert into t2 values ({x},{'aaa'},{'vvv'});

select * FROM t1;
SELECT * FROM t2;



drop t1;
drop t2;
--+ holdcas off;
