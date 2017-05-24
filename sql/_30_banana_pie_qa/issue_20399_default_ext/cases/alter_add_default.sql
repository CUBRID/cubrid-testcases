drop table if exists t1;

create class t1(c1 int, c2 set varchar(10));
insert into t1 values (1, {'abc'});
select * from t1;

alter t1 add column c3 varchar(100) default to_char(time('02:11:12'), 'HH24:MI:SS');
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;
show create table t1;
alter t1 drop column c3;

alter t1 add column c3 varchar(100) default TO_CHAR(datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST', 'MM/DD/YYYY HH24:MI TZR TZD TZH TZM');
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;
show create table t1;
alter t1 drop column c3;

alter t1 add column c3 varchar(1) default to_char(sysdatetime, 'YYYYMMDD')||'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;
show create table t1;
alter t1 drop column c3;

alter t1 add column c3 varchar(10) default to_char(sysdatetime, 'YYYYMMDD');
insert into t1(c1, c2) values(2, {'cba'});
select attr_name, default_value from db_attribute where class_name = 't1';
select c1, c2, c3=to_char(sysdatetime, 'YYYYMMDD'), c3=to_char(sysdatetime, 'YYYYMMDD') from t1;
update t1 set c3=default where c1 is not null;
show create table t1;
alter t1 drop column c3;

alter t1 add column c3 varchar(100) default to_char(sysdatetime, 'YYYYMMDD');
alter t1 add column c4 varchar(100);
insert into t1(c1, c2, c4) values(2, {'cba'}, to_char(sysdatetime, 'YYYYMMDD'));
select attr_name, default_value from db_attribute where class_name = 't1';
select c1, c2, c3=to_char(sysdatetime, 'YYYYMMDD'), nvl2(c4, c4=to_char(sysdatetime, 'YYYYMMDD'), c4) from t1;
update t1 set c3=default where c1 is not null;
show create table t1;
alter t1 drop column c3;

alter t1 add column c5 varchar(100) default to_char(systime, 'HH:MI:SS AM');
alter t1 add column c5_answer varchar(100);
alter t1 add column c6 varchar(100) default to_char(SYSTIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY');
alter t1 add column c6_answer varchar(100);
set names utf8;
alter t1  add  column c9 string collate utf8_en_ci default to_char(sysdatetime, 'HH24:MI:SS.FF YYYY-MM-DD');
alter t1 add column c9_answer varchar(100);
update t1 set c9=default, c9_answer=to_char(sysdatetime, 'HH24:MI:SS.FF YYYY-MM-DD');
update t1 set c9=default(c8);
insert into t1(c1, c5) values(7, default(cc));
insert into t1(c1, c5, c5_answer,c6_answer,c9_answer) values(7, default, to_char(systime, 'HH:MI:SS AM'),to_char(SYSTIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY'), to_char(sysdatetime, 'HH24:MI:SS.FF YYYY-MM-DD'));
select c1, c2, nvl2(c4, c4=to_char(sysdatetime, 'YYYYMMDD'), c4), c5=c5_answer, c6=c6_answer, c9=c9_answer from t1;
select if(max(c9) is not null, 'ok', 'nok') from t1 group by c9;
alter t1 add column c10 char(100) default to_char(sysdatetime, 'HH24:MI:SS DD/MM/YYYY TZR');
select if(c10 is not null, 'ok', 'nok') from t1;
update t1 set c10 = default(c9);
select if(c10 is not null, 'ok', 'nok') from  t1;
select attr_name, default_value from db_attribute where class_name = 't1' and attr_name='c10';
set names iso88591;

drop table if exists t1;
create class t1(c1 int, c2 set varchar(10));
alter table t1 add column c5 varchar(10) default to_char(SESSIONTIMEZONE(), 'HH24:MI:SS DD/MM/YYYY TZR');
show create table t1;
alter t1 drop column c5;

drop table if exists t2;
create table t2(name varchar(20) primary key default to_char(systimestamp, 'HH24:MI:SS YYYY-MM-DD'));

alter t1 add column c3 varchar(100) default to_char(19820918, 'S099999');
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;
show create table t1;
alter t1 drop column c3;

alter t1 add column c3 varchar(100) default to_char(19820918, 'S099999', 'en_us');
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;
show create table t1;
alter t1 drop column c3;


update t1 set c3 = default where c1 is not NULL;
update t1 set c3 = default to_char(time('02:11:12'), 'HH24:MI:SS') where c1 is not NULL;
delete from t1 where c3 = default(c3);
insert into t1 values(9, default to_char(sysdatetime, 'YYYYMMDD'), default);
select * from t1;
drop t1;
drop t2;
