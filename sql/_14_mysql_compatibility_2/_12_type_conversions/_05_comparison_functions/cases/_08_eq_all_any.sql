select 'ok' from db_root where '1' = any {1,2,3};

select 'ok' from db_root where 1 = any {'1','2','3'};

select 'ok' from db_root where '2010-01-01' = any {date'2010-01-01', date'2010-01-02'};

create table t (s string);
create table u (i int);

insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);

insert into u select * from t;

select i from u where u.i = some (select s from t) order by i;

drop table t;
drop table u; 

select 'ok' from db_root where '1' = all {1,'1',1.0};

select 'ok' from db_root where '2010-01-01' = all {date'2010-01-01', '2010-01-01'};

create table t (s string);
create table u (i int);

insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);

insert into u values ('1');

select i from u where u.i = all (select s from t) order by i;

$varchar, $5, $varchar, $5
select (? = all {5,5.0,?}) from db_root;

$varchar, $5, $varchar, $5
select if ((? = all {5,5.0,?}) = (5 = all {5,5.0,'5'}), 'ok','nok') from db_root;

drop table t;
drop table u; 
