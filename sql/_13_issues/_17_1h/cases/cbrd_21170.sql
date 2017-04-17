--+ holdcas on;

drop table if exists t1, t2;
create table t1(a int, b string, c string, d string);
create table t2 like t1;
update t1 join t2 on t1.a=t2.a and t2.b='a' and t2.c='b' set t1.d=t2.d;
update t1 join t2 on t1.a=t2.a and t2.b='a' and t2.c='b' set t1.d=t2.d;
drop table if exists t1, t2;

--+ holdcas off;
