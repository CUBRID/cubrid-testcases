drop table if exists t1;

create class t1(c1 int, c2 set varchar(10));
insert into t1 values (1, {'abc'});
select * from t1;

alter t1 add column c9 varchar(100);
alter t1 add column c3 varchar(100) default to_char(time('02:11:12'), 'HH24:MI:SS');
insert into t1(c1, c2) values(2, {'cba'});
select * from t1;

alter t1 alter column c3 set default to_char(TIMESTAMP'2009-10-04 22:23:00', 'Day Month yyyy');
insert into t1(c1, c2) values(3, {'ddd'});
select c1,c2,c9, if(c3 is not null, 'ok', 'nok') from t1 order by c1;

alter t1 alter column c3 set default to_char(sysdatetime, 'YYYYMMDD');
insert into t1(c1, c2, c9) values(4, {'cccc'}, to_char(sysdatetime, 'YYYYMMDD'));
select c1, c2, nvl2(c9, c9=to_char(sysdatetime, 'YYYYMMDD'), c9), if(c3 is not null, 'ok', 'nok') from t1 order by c1;

alter t1 alter column c3 set default to_char(systimestamp, 'HH24:MI:SS DD/MM/YYYY TZR');
alter t1 alter column c4 set default to_char(systimestamp, 'HH24:MI:SS DD/MM/YYYY TZR');
insert into t1(c1, c2) values(4, {'cccc'});
select case when c3=c4 then 'ok' else 'nok' end from t1 order by c1;


alter t1 alter column c3 set default to_char(sysdatetime, 'YYYYMMDD')||'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
insert into t1(c1, c2) values(5,{'eeeee'});
select c1, c2, nvl2(c9, c9=to_char(sysdatetime, 'YYYYMMDD'), c9), if(c3 is not null, 'ok', 'nok') from t1 order by c1;

alter t1 alter column c3 set default to_char(19820918, 'S099999');
insert into t1(c1, c2) values(6,{'eeeee'});
select c1,c2,nvl2(c9, c9=to_char(sysdatetime, 'YYYYMMDD'), c9), if(c3 is not null, 'ok', 'nok') from t1 order by c1;

alter t1 alter column c3 set default to_char(19820918, 'S099999', 'en_us');
insert into t1(c1, c2) values(7,{'eeeee'});
select c1,c2, nvl2(c9, c9=to_char(sysdatetime, 'YYYYMMDD'), c9), if(c3 is not null, 'ok', 'nok') from t1 order by c1;

alter t1 alter column c3 set default TO_CHAR(datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST', 'MM/DD/YYYY HH24:MI TZR TZD TZH TZM');
insert into t1(c1, c2) values(8, {'ggg'});
select c1, c2, nvl2(c9, c9=to_char(sysdatetime, 'YYYYMMDD'), c9), if(c3 is not null, 'ok', 'nok') from t1 order by c1;

show create table t1;
select default(c3) from t1;

update t1 set c3 = default where c1 is not NULL;
delete from t1 where c3 = default(c3);
insert into t1 values(9, {'YYYYMMDD'}, default);
select * from t1;

drop table if exists t1;
