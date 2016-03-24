--
create table t1(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'));
insert into t1 values (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);
select * from t1 order by 1, 2;

update t1 set e1=cast(e2 as int) where e2 < 3;
select * from t1 order by 1, 2;

update t1 set e2=e1 + 1;
select * from t1 order by 1, 2;

update t1 set e1='b', e2='No';
select * from t1 order by 1, 2;

drop table t1;