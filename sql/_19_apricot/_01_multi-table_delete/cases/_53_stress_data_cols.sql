
create class t (i int, f float, d double, v varchar(32));

insert into t values (1, 1, 1, '1'), (2, 2, 2, '2'), (3, 3, 3, '3'), (4, 4, 4, '4'), (5, 5, 5, '5'), (6, 6, 6, '6'), (7, 7, 7, '7'), (8, 8, 8, '8'),(9, 9, 9, '9'), (10, 10, 10, '10');

--insert into t select t1.* from t as t1, t as t2, t as t3, t as t4 where t4.i < 3;

create class t1 (i int, f float, d double, v varchar(32));
insert into t1 select * from t;

delete t, t1 from t inner join t1 on t.i=t1.i;

select count(*) from t order by 1;
select count(*) from t1 order by 1;

drop class t;
drop class t1;
