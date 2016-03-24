--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int, str CLOB);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');

insert into t1 values (1, 'unu');
insert into t1 values (2, 'doi');
insert into t1 values (3, 'trei');
insert into t1 values (4, 'patru');
insert into t1 values (5, 'cinci');

create table t2(i int, str1 clob, str2 clob);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');

insert into t2 values (3, 'trei', 'three');
insert into t2 values (4, 'patru', 'four');
insert into t2 values (5, 'cinci', 'five');
insert into t2 values (6, 'sase', 'six');
insert into t2 values (7, 'sapte', 'seven');

update t1 inner join t2 on t1.i=t2.i set t2.str1=t2.str2, t1.str=t2.str2, t2.i=t2.i - 1, t1.i=t1.i + 1, t2.str2=t1.str;
select i, cast(str as varchar(255)) as str from t1 order by 1, 2;
select i, cast(str1 as varchar(255)) as str1, cast(str2 as varchar(255)) as str2 from t2 order by 1, 2;
select * from t_tr order by 1, 2;

drop class t1;
drop class t2;
drop table t_tr;