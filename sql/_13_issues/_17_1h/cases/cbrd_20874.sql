drop table if exists DML_0001;
drop table if exists DML_0002;
drop table if exists DML_0003;
create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002
(	int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

create class DML_0003 under DML_0001
(int_col1 int not null);

insert into DML_0001 values (1,'test1', {1,'test1'});

insert into DML_0001 values (2,'test1', {1,'test1'});

insert into DML_0001 values (3,'test2', {1,'test2'});

insert into DML_0001 values (4,'test1', {2,'test1'});

insert into DML_0001 values (5,'test2', {2,'test2'});

WITH cte_OMKcDNWZR AS
(
select DML_0001 into a from DML_0001 where int_col > 1
)
select * from cte_OMKcDNWZR;

select DML_0001 into a from DML_0001 where int_col > 1;

WITH cte_9etttF AS
(
select timestamp(date'2001-01-01', 0)
)
select * from cte_9etttF;
select timestamp(date'2001-01-01', 0);

drop table if exists t1;
drop table if exists t2;
CREATE TABLE t1(id int);
CREATE TABLE t2(id int,a int);
insert into t1 values (1);
insert into t2 values (1,1);
WITH cte_aQbea3 AS
(
select * FROM t1 WHERE id in (SELECT id FROM t2)
)
select * from cte_aQbea3;
WITH cte_JpLhlq AS
(
select * FROM t1 WHERE id in (SELECT id FROM t2 ORDER BY a)
)
select * from cte_JpLhlq;
WITH cte_JpLhlad AS
(
select * FROM t1 WHERE id in (SELECT id FROM t2 ORDER BY a limit 2)
)
select * from cte_JpLhlqad;

drop table if exists t1;
drop table if exists t2;
drop table if exists DML_0001;
drop table if exists DML_0002;
drop table if exists DML_0003;


