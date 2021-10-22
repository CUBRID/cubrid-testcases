-- 1. check to_char in default clause.
drop table if exists t1;

-- (1). test EXPR,it should be failed.
create table t1(s1 varchar default to_char(SYSTIME-60,'HH:MI:SS AM'));

create table t1(s1 string default to_char(SUBDATE(SYSDATE,INTERVAL 24 HOUR),'HH:MI:SS.FF AM MM/DD/YYYY'),s2 varchar);

create table t1(s1 datetime default cast(TO_CHAR(SYS_DATETIME, 'HH:MI:SS.FF AM MM/DD/YYYY') as datetime));

-- success
create table t1(s1 varchar default TO_CHAR(SYS_DATETIME, 'HH:MI:SS.FF AM MM/DD/YYYY'||'MM/DD/YYYY'));

drop t1;

-- failed,subquery is not allowed
drop table if exists t1;

create table t1(s1 varchar default (select to_char(sysdate,'YYYY-MM-DD')),s2 varchar);

-- (2). test NAME,it should be failed.
drop table if exists t1;

create table t1(d1 DATE,s2 varchar default d1);

-- (3). constant literal,it is ok.
create table t1(s1 varchar default '05-05-2017');

select attr_name,default_value from db_attribute where class_name='t1';

drop table t1;

-- (4). invalid format,it should be failed.
drop table if exists t1;

create table t1(s1 varchar default to_char(sysdate,'MM-SS-YYYY'));

create table t1(s1 varchar default to_char(systime,'MM-DD-YYYY'));

create table t1(s1 varchar default to_char(systimestamp,'HH:MI:SS.FF AM MM/DD/YYYY'));

-- success
create table t1(s1 varchar default to_char(sysdatetime,'HH:MI:SS AM MM/DD/YYYY')); 

select attr_name,default_value from db_attribute where class_name='t1';

drop t1;

-- Not allowed(CBRD-21272)
drop table if exists t1;

create table t1(s1 varchar default to_char(sysdatetime,'HH:MI:SS.FF AM MM/DD/YYYY','ko_KR'),s2 varchar);

create table t1(s1 varchar default to_char('04:03:58.121 ohu 05/10/2017','HH:MI:SS.FF AM MM/DD/YYYY','ko_KR'),s2 varchar); 

create table t1(s1 varchar default to_char(1.234567,'99.999','ko_KR'));

-- (6). datetime with time zone
drop table if exists t3;

create table t3(s1 varchar default to_char(sysdatetime,'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

insert into t3(s2) values(to_char(sysdatetime,'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t3;

select attr_name,default_value from db_attribute where class_name='t3' order by 1;

drop t3;


-- (5). timestamp with time zone
-- bug CBRD-21261
SET TIME ZONE 'America/Los_Angeles';

drop table if exists t2;

create table t2(s1 varchar default to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'),s2 varchar,s3 varchar default to_char(systimestamp,'HH:MI:SS AM MM/DD/YYYY TZR'),s4 varchar);

insert into t2(s2,s4) values(to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'),to_char(systimestamp,'HH:MI:SS AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok'),if(s3=s4,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2' order by 1;

drop t2;

SET TIME ZONE 'Asia/Seoul';


-- (7). CURRENT_TIMESTAMP
drop table if exists t4;

create table t4(s1 varchar default to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY'),s2 varchar);

insert into t4(s2) values(to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY'));

select if(s1=s2,'ok','nok') from t4;

select attr_name,default_value from db_attribute where class_name='t4' order by 1;

drop t4;

-- (8). time
drop table if exists t5;

create table t5(s1 varchar default to_char(systime,'HH:MI:SS AM'),s2 varchar);

insert into t5(s2) values(to_char(systime,'HH:MI:SS AM'));

select if(s1=s2,'ok','nok') from t5;

select attr_name,default_value from db_attribute where class_name='t5' order by 1;

drop t5;

-- (9). date
drop table if exists t6;

create table t6(s1 varchar default to_char(sysdate,'MM-DD-YYYY'),s2 varchar);

insert into t6(s2) values(to_char(sysdate,'MM-DD-YYYY'));

select if(s1=s2,'ok','nok') from t6;

select attr_name,default_value from db_attribute where class_name='t6' order by 1;

drop t6;


-- 2. test other function(to_time) in default clause.
drop table if exists t7;
-- it should be failed.
create table t7(s1 time default TO_TIME(systime, 'HH24:MI:SS'));

-- success
create table t7(s1 time default TO_TIME('12:23:23', 'HH24:MI:SS'));

insert into t7 values default;

select * from t7;

drop t7;






