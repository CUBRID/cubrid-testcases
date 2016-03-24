--SERVER
create table t1(i int, str CLOB);

insert into t1 values (1, 'unu');
insert into t1 values (2, 'doi');
insert into t1 values (3, 'trei');
insert into t1 values (4, 'patru');
insert into t1 values (5, 'cinci');

create table t2(i int, str1 clob, str2 clob);

insert into t2 values (3, 'trei', 'three');
insert into t2 values (4, 'patru', 'four');
insert into t2 values (5, 'cinci', 'five');
insert into t2 values (6, 'sase', 'six');
insert into t2 values (7, 'sapte', 'seven');

delete t1, t2 from t1, t2 where t1.i=t2.i;
select i, cast(str as varchar(255)) as str from t1 order by 1;
select i, cast(str1 as varchar(255)) as str1, cast(str2 as varchar(255)) as str2 from t2 order by 1;

drop class t1;
drop class t2;