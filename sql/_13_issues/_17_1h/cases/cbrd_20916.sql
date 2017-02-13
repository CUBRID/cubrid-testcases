drop table if exists t1,t2,t3;
create table t1 (a int, b  char(32));
insert into t1 values(4,'aaaa' );
insert into t1 values (7,'bb');
insert into t1 values (1,'ccc');
insert into t1 values (4,'dd');  
insert into t1 values(3,'eee');
 insert into t1 values (7,'bb');
 insert into t1 values (1,'fff');
 insert into t1 values(4,'ggg');
create table t2 (c int);
insert into t2 values(2);
insert into t2 values(4);
insert into t2 values(5);
insert into t2 values(3);
                   
with  t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with  t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a);
drop table if exists t1,t2,t3;
