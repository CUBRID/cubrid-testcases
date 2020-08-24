set system parameters 'create_table_reuseoid=no';
-- 1. check the existing default clause is ok
drop table if exists t1;
drop table if exists t1_a;
drop table if exists t1_l;
drop table if exists t1_t;

create table t1(i1 int,s1 varchar default to_char(12345,'S999999'),s2 TIMESTAMP default SYSTIMESTAMP,s3 TIMESTAMP);

insert into t1(i1,s3) value(1,SYSTIMESTAMP);

select i1,s1,if(s2=s3,'ok','nok') from t1 order by 1;

-- create..as..
create table t1_a as select * from t1;

insert into t1_a(i1,s3) value(2,SYSTIMESTAMP);

select i1,s1,if(s2=s3,'ok','nok') from t1_a order by 1;

-- create..like..
create table t1_l like t1;

insert into t1_l(i1,s3) value(1,SYSTIMESTAMP);

select s1,if(s2=s3,'ok','nok') from t1_l order by 1;


select attr_name,default_value from db_attribute where class_name='t1' order by 1;

select attr_name,default_value from db_attribute where class_name='t1_a' order by 1;

select attr_name,default_value from db_attribute where class_name='t1_l' order by 1;


create table t1_t(col1 t1);

insert into t1_t values(insert into t1(i1,s3) value(2,SYSTIMESTAMP));

select if(col1.s2=col1.s3,'ok','nok') from t1_t;

drop table t1;

drop table t1_a;

drop table t1_l;

drop table t1_t;


-- 2. check the extension default clause
drop table if exists t2;
drop table if exists t2_a;
drop table if exists t2_l;
drop table if exists t2_t;

create table t2(s1 varchar default to_char(SYSDATETIME,'YYYY-MM-DD HH24:MI'),s2 varchar);

insert into t2(s2) values(to_char(SYSDATETIME,'YYYY-MM-DD HH24:MI'));

select if(s1=s2,'ok','nok') from t2;

-- create..as..
create table t2_a as select * from t2;

insert into t2_a(s2) values(to_char(SYSDATETIME,'YYYY-MM-DD HH24:MI'));

select if(s1=s2,'ok','nok') from t2_a;

-- create..like..
create table t2_l like t2;

insert into t2_l(s2) values(to_char(SYSDATETIME,'YYYY-MM-DD HH24:MI'));

select if(s1=s2,'ok','nok') from t2_l;


select attr_name,default_value from db_attribute where class_name='t2' order by 1;

select attr_name,default_value from db_attribute where class_name='t2_a' order by 1;

select attr_name,default_value from db_attribute where class_name='t2_l' order by 1;


create table t2_t(col1 t2);

insert into t2_t values(insert into t2(s2) values(to_char(SYSDATETIME,'YYYY-MM-DD HH24:MI')));

select if(col1.s1=col1.s2,'ok','nok') from t2_t;

drop table t2;

drop table t2_a;

drop table t2_l;

drop table t2_t;





set system parameters 'create_table_reuseoid=yes';
