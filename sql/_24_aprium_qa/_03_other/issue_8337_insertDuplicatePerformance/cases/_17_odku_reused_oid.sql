
drop class  if exists t1,t2,t3;


create class t1(i int) reuse_oid;
insert into t1 values (1), (2), (3);
create unique index u_t_i on t1(i);

create class t2(i int) reuse_oid;
insert into t2 values (2), (3), (1);

create class t3(i int) reuse_oid;
insert into t3 values (2), (3), (1);

select * from t1 order by 1;

delete from t1;
insert into t1 values (1), (2), (3);
delete from t2
insert into t2 values (1), (2), (3);
delete from t3
insert into t3 values (1), (2), (3);
insert into t1(i) (select * from t2 union select * from t3 ) on duplicate key update t1.i=i-100;

select * from t1 order by 1;

drop class t1;
drop class t2;
drop class t3;