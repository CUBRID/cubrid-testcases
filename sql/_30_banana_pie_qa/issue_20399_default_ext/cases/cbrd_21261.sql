--+ holdcas on;
-- Test default clause with timezone
-- bug CBRD-21261

SET TIME ZONE 'America/Los_Angeles';

-- CURRENT_TIMESTAMP
drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY TZR'),s2 varchar);

insert into t2(s2) values(to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY TZR')); 

insert into t2(s2) values(to_char(CURRENT_TIMESTAMP,'HH:MI:SS AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


-- CURRENT_DATETIME
drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

insert into t2(s2) values(to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR')); 

insert into t2(s2) values(to_char(CURRENT_DATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;



-- CURRENT_DATE
drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_DATE,'MM/DD/YYYY'),s2 varchar);

insert into t2(s2) values(to_char(CURRENT_DATE,'MM/DD/YYYY'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_DATE,'MM/DD/YYYY'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(CURRENT_DATE,'MM/DD/YYYY')); 

insert into t2(s2) values(to_char(CURRENT_DATE,'MM/DD/YYYY'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


-- CURRENT_TIME
drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_TIME,'HH:MI:SS AM TZR'),s2 varchar);

insert into t2(s2) values(to_char(CURRENT_TIME,'HH:MI:SS AM TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(CURRENT_TIME,'HH:MI:SS AM TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(CURRENT_TIME,'HH:MI:SS AM TZR')); 

insert into t2(s2) values(to_char(CURRENT_TIME,'HH:MI:SS AM TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


-- LOCALTIME
drop table if exists t2;

create table t2(s1 varchar default to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'),s2 varchar);

insert into t2(s2) values(to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR')); 

insert into t2(s2) values(to_char(LOCALTIME,'HH:MI:SS AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


-- NOW
drop table if exists t2;

create table t2(s1 varchar default to_char(NOW(),'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

insert into t2(s2) values(to_char(NOW(),'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(NOW(),'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(NOW(),'HH:MI:SS.FF AM MM/DD/YYYY TZR')); 

insert into t2(s2) values(to_char(NOW(),'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;



-- SYSDATETIME
drop table if exists t2;

create table t2(s1 varchar default to_char(SYSDATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

insert into t2(s2) values(to_char(SYSDATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;


drop table if exists t2;

create table t2(s1 varchar default to_char(SYSDATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'),s2 varchar);

create trigger tr_t2 before delete on t2 execute insert into t2(s2) values (to_char(SYSDATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR')); 

insert into t2(s2) values(to_char(SYSDATETIME,'HH:MI:SS.FF AM MM/DD/YYYY TZR'));

select if(s1=s2,'ok','nok') from t2;

delete from t2;

select if(s1=s2,'ok','nok') from t2;

select attr_name,default_value from db_attribute where class_name='t2';

drop table t2;



SET TIME ZONE 'Asia/Seoul';

--+ holdcas off;