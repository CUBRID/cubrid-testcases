drop  table if exists t1;
--error since the length is too short
create table t1(i int primary key, k varchar(10) default to_char(SYSTIMESTAMP, 'HH24:MI:SS YYYY-MM-DD'));
create table t1(i int primary key, k varchar(50) default to_char(SYSTIMESTAMP, 'HH24:MI:SS YYYY-MM-DD'));
insert into t1(i) values (1), (2);
insert into t1 values(3, 'dddd'), (4, default(k)),(5, to_char(datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST', 'MM/DD/YYYY HH24:MI TZR TZD TZH TZM'));

drop table if exists t2;
create table t2(i int not NULL  default'111111', kk set varchar(10) default {'aaa','bbbccc'} );
insert into t2(i) values (1), (2);
insert into t2 values (3, default(kk));
insert into t2 values (4, default);

create view v1 as select t1.i as t1i, t2.i as t2i from t1 inner join t2 on t1.i=t2.i where t1.i > 3;
create view v2 as select * from t1 where i < 5;

select * from v1 order by 1, 2;
select (k regexp '^[0-9].*[0-9]$') as default_value from v2 order by 1;

show create view v1;
show create view v2;

update t1, v1, t2, v2 set v1.t1i=3, v2.i=4, t1.i=5, t2.i=6;
update v2 set k=to_char(SYSTIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY');
update v2 set k=default;

select (k regexp '^[0-9].*[0-9]$') as default_value from v2 order by 1;
drop view v1;
drop view v2;
drop table t1;
drop table t2;
