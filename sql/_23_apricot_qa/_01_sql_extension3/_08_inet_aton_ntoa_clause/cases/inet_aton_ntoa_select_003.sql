--inet_aton_ntoa_select_003.sql
SELECT INET_NTOA(-1);
SELECT INET_ATON('-1.0.5.9');
SELECT INET_ATON('1.-1.5.9');
SELECT INET_ATON('1.0.-1.9');
SELECT INET_ATON('1.0.5.-1');

SELECT INET_NTOA(256);
SELECT INET_ATON('256.0.5.9');
SELECT INET_ATON('1.256.5.9');
SELECT INET_ATON('1.0.256.9');
SELECT INET_ATON('1.0.5.256');

SELECT INET_ATON('\0.0.5.256');
SELECT INET_ATON('\n.0.5.256');
SELECT INET_ATON('\t.0.5.256');
SELECT INET_ATON('\\0.0.5.256');

SELECT INET_ATON('0.\0.5.256');
SELECT INET_ATON('0.\n.5.256');
SELECT INET_ATON('0.\t.5.256');
SELECT INET_ATON('0.\\0.5.256');

SELECT INET_ATON('0.\0.5.256');
SELECT INET_ATON('0.\n.0.5.256');
SELECT INET_ATON('0.\t.0.5.256');
SELECT INET_ATON('0.\\0.0.5.256');


SELECT  inet_aton('127.1');


SELECT  inet_aton(NULL);

SELECT  inet_aton(NULL||'127.0.0.1');
SELECT  inet_aton('127.0.0.1'||NULL);
SELECT  inet_aton('127.0.0.1'+NULL);
SELECT  inet_aton(~NULL);
SELECT  inet_aton(!1);

select inet_aton('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

--bug
drop table if exists t;
create table t; select inet_aton('127.0.0.1') as i;
drop table if exists t;


select inet_aton('127.0.0.1');

drop table if exists t;
create table t; select 1 as i;
insert into [t] values();
select count(*) from t;
select * from t;
drop table if exists t;


drop table if exists t;
create table t; select 1 as i;
insert into t values();
select * from t;
drop table if exists t;

drop table if exists t,t1;
create table t1 (i int);
insert t1 values(1);
create table t; select * from t1;
select * from t;
drop table if exists t,t1;

drop table if exists t;
create table t; select 1 as i;
insert into [t] values(select (values(1)));
select count(*) from t;
select * from t;
drop table if exists t;
