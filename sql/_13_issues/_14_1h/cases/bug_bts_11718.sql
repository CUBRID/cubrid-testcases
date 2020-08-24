set system parameters 'create_table_reuseoid=no';
drop table if exists t1;
drop view if exists v1;

create table t1 ( a int , b int);
insert into t1 values (1, 2);
create view v1 as select * from t1 order by b;

insert into v1 select a+1, b+1 from v1 order by b limit 1;
insert into v1 select a, b from v1 order by b ASC limit 1;

insert into v1 select a+b, b-a from v1 order by a limit 2;
insert into v1 select sum(a)/max(a), sum(b)/(min(b)+1) from v1 order by a;
insert into v1 values(9, select distinct a+b from v1 where a=1);

insert into v1 select a, b from v1 order by a+b DESC limit 2;
insert into v1 select a, b from v1 group by a+b DESC limit 2;

select * from v1 order by a,b;

drop table t1;
drop view v1;

create table t1 ( a int , b int,c int);
insert into t1 values (1, 2, 3);
create view v1 as select * from t1 order by a;

insert into v1 select a+1, b+1, c+1 from v1 order by b limit 1;
insert into v1 select a+b, b-a, c+b from v1 order by a limit 2;

insert into v1 select a, b, c from v1 order by a+b+c,a limit 2;
insert into v1 select max(a), max(b), max(c) from v1 group by a+b+c;

select * from v1 order by a,b,c;
drop table t1;
drop view v1;

create table t1 ( a varchar(4) , b varchar(20));
insert into t1 values ('12', 'aa');
create view v1 as select * from t1 order by a;
insert into v1 select a+'b', b+'ss' from v1;

select * from v1 order by a,b;

drop table t1;
drop view v1;
set system parameters 'create_table_reuseoid=yes';
