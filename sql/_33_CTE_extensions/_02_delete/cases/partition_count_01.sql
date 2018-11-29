drop table if exists foo,range_test;
create table range_test(id int not null ,
test_int int,
test_smallint smallint,
test_numeric numeric(38,10),
test_float float,
test_real real,
test_double double,
test_monetary monetary,
test_datetime timestamp,primary key(id,test_int))
PARTITION BY RANGE (test_int) (
PARTITION p0 VALUES LESS THAN (10)
);

insert into range_test values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
insert into range_test values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
insert into range_test values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');
select * from range_test a, range_test b order by a.id, b.id;


drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte(a,b) AS
(
select a.test_int, b.test_int from range_test a, range_test b where a.test_int =1.0 order by 1,2
)
delete from t where i <=(select count(*) from mycte);

drop table range_test;




drop table if exists hash_test;
create table hash_test(id int not null ,
test_int int,
test_smallint smallint,
test_numeric numeric(38,10),
test_float float,
test_real real,
test_double double,
test_monetary monetary,
test_datetime timestamp,primary key(id,test_int))
PARTITION BY hash (test_int) 
partitions 4;

insert into hash_test values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
insert into hash_test values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
insert into hash_test values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');
select * from hash_test a, hash_test b order by a.id, b.id;


drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte(a,b) AS
(
select a.test_int, b.test_int from hash_test a, hash_test b where a.test_int =1.0 order by 1,2
)
delete from t where i <=(select count(*) from mycte);


create table foo as
with cte(a,b) as
(
select a.test_int, b.test_int from hash_test a, hash_test b where a.test_int =1.0 order by 1,2
)select * from cte;


insert into foo
with cte(a,b) as
(
select a.test_int, b.test_int from hash_test a, hash_test b where a.test_int =1.0 order by 1,2
) select * from cte;
select * from foo order by 1,2;

with cte(a,b) as
(
select a.test_int, b.test_int from hash_test a, hash_test b where a.test_int =1.0 order by 1,2
) delete from foo where a= some(select a from cte) and b>=2;
select * from foo order by 1,2;


with cte(a,b) as
(
select a.test_int, b.test_int from hash_test a, hash_test b where a.test_int =1.0 order by 1,2
) update foo set b=-1 where a= some(select a from cte);
select * from foo order by 1,2;

drop table if exists foo,hash_test;
