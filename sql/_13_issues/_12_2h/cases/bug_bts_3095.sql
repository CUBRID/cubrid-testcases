drop table if exists t1;

create view v1 as select 1 id from db_root;

alter view v1 as select * from v1;

select * from v1;

drop view v1;

create table t1 (a int, b int);

create view v2 as select * from t1;

create or replace view v2 as select * from v2;

select * from v2;

drop table t1;

drop view v2;

drop table if exists t1,t2,t3;

create table t1 (a int);
create table t2 (b int);
create view v1 as select * from t1;
create or replace view v1 as select * from t2, v1;


create view v2 as select 1 as id from db_root;
create view v3 as select * from v2;
create or replace view v2 as select * from v3;
drop view v3;

create view v4 as select 1 id;
alter view v4 as select * from v4 v;


create table t3 (a int, b int);
create or replace view t3 as select * from t3;

drop table if exists t1,t2,t3;

drop view v1,v2,v4;

create view v1 as select * from db_class;

alter view v1 as (select * from db_class) union (select * from db_class) ;

alter view v1 as (select * from db_class) union (select * from db_class v1) ;

alter view v1 as select distinct * from ((select * from db_class) union (select * from db_class v1) union all (select * from db_class v1)) ;

create table t1( v1 int);

alter view v1 as (select * from t1) union (select v1 from t1 v1) ;

alter view v1 as (insert into t1 select * from t1);

alter view v1 as (insert into v1 select * from t1);

select * from v1;

drop view v1;

drop table if exists t1;

create view v1 as select 1 id from db_root limit 10;

alter view v1 as select * from v1;

select * from v1;

drop view v1;

create table t1 (a int, b int) partition by hash(a) partitions 3;

insert into t1 select rownum,rownum from db_class limit 3;

create view v2 as select * from t1;

create or replace view v2 as select * from t1__p__p0;

create or replace view v2 as select * from t1__p__p1;

create or replace view v2 as select * from t1__p__p2;

create or replace view v2 as select * from t1;

select * from v2 order by 1,2;

drop table t1;
drop view v2;
