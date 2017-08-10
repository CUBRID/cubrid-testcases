create class t (i int);
insert into t values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
--insert into t select t1.* from t as t1, t as t2, t as t3, t as t4 where t4.i < 3;

create class t__001 (i int);
insert into t__001 select * from t;

delete t, t__001 from t inner join t__001 on t.i=t__001.i;

select count(*) from t order by 1;
select count(*) from t__001 order by 1;

drop class t;
drop class t__001;
