drop table if exists t0;
create table t0(id int default to_char(sysdate, 'DD'));
insert into t0 value default;
select * from t0;
show create table t0;
alter t0 alter id set default to_char(sysdate, 'YY');
insert into t0 value default;
select * from t0
show create table t0;

drop table if exists ta;
create table ta(d varchar(100) default to_char(sysdate, 'YYYY-MM-DD') UNIQUE, answer varchar);
insert into ta value (default, to_char(sysdate, 'YYYY-MM-DD'));
insert into ta value (default(d), to_char(sysdate, 'YYYY-MM-DD'));
select d=answer from ta;

drop table if exists t3;
create table t3 (c1 int  DEFAULT to_char(sysdate, 'YYYY')  not null);
show create table t3;
insert into t3 values default;
alter table t3 add column c2 varchar default to_char(systime,'HH') not null;
show create table t3;
drop table if exists t3;

drop table if exists xoo;
create class xoo ( id int primary key default to_char(sysdate, 'MM'), title varchar(100));
insert into xoo value default;
alter table xoo modify title varchar default to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY');
select * from xoo;
prepare xx from 'update xoo set title=default(title) where id =?'; 
execute xx using '5';
prepare xx from 'update xoo set title=default(title)||? where id =?';
execute xx using '- Meeting', '5';
deallocate prepare xx;
drop table if exists xoo;

drop table if exists t1;
create class t1 (c1 varchar DEFAULT to_char(systime, null) null, c2 varchar);
insert into t1(c1, c2) values (default, systime);
insert into t1(c1, c2) values (default(c1), systime);
select case 
           when c1=c2 then 'ok' 
           else 'nok'
        end from t1;
alter t1 add column c varchar default to_char(sysdatetime, NULL);
alter t1 add column c3 varchar;
select c from t1;
update t1 set c = default, c3=sysdatetime;
update t1 set c = default(c), c3=sysdatetime;
select case when c=c3 then 'ok' else 'nok' end from t1;
drop t1;
drop table if exists t5;
create table t5(name varchar default to_char(systimestamp, 'CC YYYY YY Q MM MONTH MON DD DAY DY AM PM A.M. P.M. HH HH12 HH24 MI SS'), n2 varchar);
show create  table t5;
insert into t5 values (default, systimestamp);
alter table t5 add column c1 varchar(50) default to_char(systimestamp, 'CC YYYY YY Q MM MONTH MON DD DAY DY');
alter table t5 add column c1_answer varchar(50);
insert into t5(name, n2) values (default, systimestamp);
select if(name is not null, 'ok', 'nok'), if(n2 is not null, 'ok', 'nok') from t5;
alter table t5 alter c1 set default to_char(systimestamp, 'cc yyyy yy q mm month mon dd day dy am pm a.m. p.m. hh hh12 hh24 mi ss');
show create  table t5;
drop table if exists t5;
drop table if exists t0;
