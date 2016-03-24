--SERVER
create class t1(i int) reuse_oid;
insert into t1 values (1), (2), (3), (4), (5), (6);

create class t2(i int) reuse_oid;
insert into t2 values (2), (3), (4), (5), (6), (7);

create class t3(i int) reuse_oid;
insert into t3 values (3), (4), (5), (6), (7), (8);

delete t2, t3 from t1 inner join t2 on t1.i=t2.i inner join t3 on t2.i=t3.i;
commit;

insert into t2 values (10), (11);
insert into t3 values (12), (13);
commit;

select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop class t1;
drop class t2;
drop class t3;