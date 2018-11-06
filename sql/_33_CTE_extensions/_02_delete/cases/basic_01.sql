

drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a monetary);
insert into xoo values(7),(7),(7);

WITH mycte AS
(
select * from xoo where a = cast(7 as monetary)
)
delete from t where i <=(select count(*) from mycte);

drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a monetary);

WITH mycte AS
(
select * from xoo where a = 7
)
delete from t where i <=(select count(*) from mycte);

drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a nchar(10));
insert into xoo values(7),(7),(7);
WITH mycte AS
(
select * from xoo where a = cast(7 as monetary)
)
delete from t where i <=(select count(*) from mycte);


drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a nchar(10));
insert into xoo values(7),(7),(7);
WITH mycte AS
(
select * from xoo where a = cast(3 as bit)
)
delete from t where i <=(select count(*) from mycte);



drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a nchar(10));
insert into xoo values(2),(2),(2);
WITH mycte AS
(
select * from xoo where a = cast(2 as nchar)
)
delete from t where i <=(select count(*) from mycte);


drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a monetary);
insert into xoo values(3),(4),(3);
WITH mycte AS
(
select * from xoo where a = cast(3 as bit)
)
delete from t where i <=(select count(*) from mycte);

;au off
drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a monetary);
insert into xoo values(3),(4),(3);
WITH mycte AS
(
select * from xoo where a = cast(3 as bit)
)
delete from t where i <=(select count(*) from mycte);
;au on

drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a monetary);
insert into xoo values(3),(4),(3);
WITH mycte AS
(
select * from xoo where a = 3
)
delete from t where i <=(select count(*) from mycte);


drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
create table xoo ( a timestamp);
WITH mycte AS
(
select * from xoo where a = time'01:01:02'
)
delete from t where i <=(select count(*) from mycte);

drop table if exists t,xoo;
create table t(i int);
insert into t(i) values(1),(2),(3);
WITH mycte AS
(
select round(15.456,1) from db_root
)
delete from t where i <=(select count(*) from mycte);

