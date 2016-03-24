--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int, str CLOB);
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.i, 't1');

insert into t1 values (1, 'unu');
insert into t1 values (2, 'doi');
insert into t1 values (3, 'trei');
insert into t1 values (4, 'patru');
insert into t1 values (5, 'cinci');

create table t2(i int, str1 clob, str2 clob);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.i, 't2');

insert into t2 values (3, 'trei', 'three');
insert into t2 values (4, 'patru', 'four');
insert into t2 values (5, 'cinci', 'five');
insert into t2 values (6, 'sase', 'six');
insert into t2 values (7, 'sapte', 'seven');

delete t1, t2 from t1, t2 where t1.i=t2.i;
select i, cast(str as varchar(255)) as str from t1 order by 1;
select i, cast(str1 as varchar(255)) as str1, cast(str2 as varchar(255)) as str2 from t2 order by 1;
select * from t_tr order by 1, 2;

drop class t1;
drop class t2;
drop class t_tr;