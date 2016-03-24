drop table if exists t1;
drop table if exists t2;

CREATE TABLE t1 (a varchar(200),b varchar(200));
INSERT INTO t1 VALUES ('aaabbb','aaabbb'), ('aaa%','aaa%');

CREATE TABLE t2 (a varchar(200),b varchar(200));
INSERT INTO t2 VALUES ('aaabbb','aaabbb'), ('aaa%','aaa%');

merge into t2
using t1
on (t1.a!=t2.a)
when matched then
update
set t2.b=t1.b
when not matched then
insert
values(t1.a, t1.b)
where t2.a is null;

drop table t1;
drop table t2;

create table t1(a set(int, char(1)),b set(int, char(1)));
insert into t1 values({1, 2, 3}, {1, 1, 3, 'a'});
create table t2(a set(int, char(1)),b set(int, char(1)));
insert into t2 values({1, 2, 3}, {1, 1, 3, 'a'});

merge into t2
using t1
on (t1.a=t2.a)
when matched then
update
set t2.b=t1.b
when not matched then
insert
values(t1.a, t1.b)
where t2.a is null;

drop table if exists t1;
drop table if exists t2;
