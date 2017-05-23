-- 1. test limit length of column with default clause.
drop table if exists t1;

create table t1(s1 varchar(2) default to_char(sysdate,'MM-DD-YYYY'));

create table t1(i1 int,s1 char(3) default 'aaaaaaaaa');

create table t1(i1 int,s1 char(3) default to_char('2017-05-09','YYYY-MM-DD'));

create table t1(s1 char(3) default to_char(1.234567,'99.999'));

create table t1(a1 varchar(2) default USER); 

create table t1(a1 varchar(2) default to_char(sysdate));

create table t1(s1 varchar(2) default ('a'+'a'+'a'));

create table t1(s1 varchar(2) default concat('a','aa'));

create table t1(s1 varchar(2) default ('a'||'abc'));

-- ok
create table t1(a1 varchar(3) default USER);

alter table t1 change a1 a1 char(2) default user;

drop table if exists t1;

--alter table change/modify column
drop table if exists t1;

create table t1(s1 varchar default to_char(sysdate,'MM-DD-YYYY'));

alter table t1 modify s1 char(3) default to_char(sysdate,'MM-DD-YYYY');

alter table t1 change s1 s1 char(3) default to_char('2017-05-09','MM-DD-YYYY'); 

alter table t1 modify s1 char(3) default to_char(1.234567,'99.999'); 

alter table t1 change s1 s1 char(3) default 'bbbbbbbbbb'; 

alter table t1 modify s1 char(3) default to_char(sysdate); 


--alter table add new column
alter table t1 add column s2 char(3) default to_char(sysdate,'MM-DD-YYYY');

alter table t1 add column s2 char(2) default user; 

-- alter table set default clause
drop table if exists t1;

create table t1(s1 varchar(1));

-- bug CBRD-21317
alter table t1 alter column s1 set default to_char(sysdate,'MM-DD-YYYY');

alter table t1 alter column s1 set default 'bbbbbbbbbb';

alter table t1 alter column s1 set default to_char(1.234567,'99.999');

alter table t1 alter column s1 set default to_char('2017-05-09','MM-DD-YYYY');

alter table t1 alter column s1 set default user;

alter table t1 alter column s1 set default to_char(sysdate);

drop table if exists t1;


-- 2. test the string length of default clause
drop table if exists t2_1;

drop table if exists t2_2;

drop table if exists t2_3;

create table t2_1(i1 int,s1 varchar default to_char(repeat('a',1000),'MM-DD-YYYY'));

-- bug CBRD-21263
create table t2_2(i1 int,s1 varchar default to_char(sysdate,repeat('MM-DD-YYYY',1000)));

-- bug CBRD-21271
create table t2_2(i1 int,s1 varchar default to_char(sysdate,repeat('MM-DD-YYYY',100)));

create table t2_2(s1 varchar default to_char(systimestamp,concat('MM-DD-YYYY','HH:MM:SS')),s2 varchar);

insert into t2_2(s2) values(to_char(systimestamp,concat('MM-DD-YYYY','HH:MM:SS')));

select if(s1=s2,'ok','nok') from t2_2;

create table t2_3(i1 int,s1 varchar default to_char(repeat(sysdate,1000),'MM-DD-YYYY')); 

drop t2_1;

drop t2_2;

drop t2_3;


-- 3. check value of column on the existing rows when one new column is added
drop table if exists t3;

create table t3(i1 int);

insert into t3 values(1),(2),(3);

alter table t3 add s2 varchar default 'test';

alter table t3 add s3 varchar default to_char(123.4567,'99999.999');

-- filled with current time
alter table t3 add s4 varchar default to_char(systimestamp,'HH:MI:SS AM MM/DD/YYYY');

alter table t3 add s5 varchar default to_char('06:07:44 PM 05/09/2017','HH:MI:SS AM MM/DD/YYYY');

-- isnull(s4) is 0
select i1,s2,s3,isnull(s4),s5 from t3 order by 1; 

insert into t3(i1) values(4);

select i1,s2,s3,isnull(s4),s5 from t3 order by 1; 

drop t3;


-- 4. shared
drop table if exists t1;

create table t1(i1 int,s1 varchar shared to_char(sysdate,'YYYY-MM-DD'),s2 varchar default to_char(sysdate,'YYYY-MM-DD')); 

insert into t1(i1) values(1);

select i1,if(s1=s2,'ok','nok') from t1; 

drop t1;


-- 5. check when error occurs(unique constraint violations),whether the default value was updated.
drop table if exists t1;

create table t1(i1 int,s1 varchar default to_char(sysdatetime,'HH:MI:SS.FF AM MM/DD/YYYY')); 

insert into t1(i1) values(1),(2);

select count(distinct(s1)) from t1;

alter table t1 add primary key(i1);

insert into t1(i1) values(1);

select count(distinct(s1)) from t1;

drop t1;

-- 7.
drop table if exists t1;

create table t1(i1 int,s1 varchar default TO_CHAR(TIMESTAMP'2017-05-09 22:23:00', 'Day Month yyyy'));

insert into t1(i1) values(1);

select * from t1;

drop t1;


-- 8. string convert to date type with default clause
-- bug CBRD-21274
drop table if exists t1;

create table t1(s1 timestamp default to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY'),s2 varchar); 

insert into t1(s2) values(default(s1));

select if(s1=s2,'ok','nok') from t1;

drop t1;

drop table if exists t1;
create table t1(i1 int,s1 timestamp default to_char('03:56:46 PM 05/10/2017', 'HH:MI:SS AM MM/DD/YYYY'));  

insert into t1(i1) values(1);

select * from t1;

drop t1;