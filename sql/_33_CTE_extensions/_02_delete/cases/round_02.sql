drop table if exists range_test;
create table range_test (id int,
test_int int,
test_char char(10))
partition by range(test_int) (
partition p0 values less than (10),
partition p1 values less than (20),
partition p2 values less than maxvalue);
insert into range_test values(0,-1,'-1');
insert into range_test values(1,1,'1');
insert into range_test values(2,2,'2');
insert into range_test values(3,11,'11');
insert into range_test values(4,12,'12');
insert into range_test values(5,21,'21');
insert into range_test values(6,22,'22');
insert into range_test values(7,2007,'2007');
insert into range_test values(8,4,'4');
insert into range_test values(9,5,'5');
insert into range_test values(10,16,'16');

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte AS
(
select * from range_test where test_int = round(11.57) order by 1
)
delete from t where i <=(select id from mycte);


drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte AS
(
select * from range_test where test_int = round(11.57) order by 1
)
delete from t where i <=(select id from mycte);


drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3),(50);
WITH mycte AS
(
select * from range_test where test_int = 12 order by 1
)
delete from t where i <=(select max(id) from mycte);

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3),(50);
WITH mycte AS
(
select * from range_test where test_int = 12 order by 1
)
delete from t where i >=(select min(id) from mycte);

drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3),(50);
WITH mycte AS
(
select * from range_test where test_int = 12 order by 1
)
delete from t where i >(select id from mycte);



drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3),(50);
WITH mycte AS
(
select * from range_test where test_int = 12 order by 1
)
delete from t where i <=any(select id from mycte);


WITH mycte AS
(
select * from range_test where test_int = round(11.57) order by 1
) select id from mycte;
