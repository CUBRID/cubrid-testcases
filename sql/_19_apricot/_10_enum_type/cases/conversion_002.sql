--conversion from enum to string types.
create table t1(e1 enum('char', 'varchar', 'EF121', '1234567890ABCDEF', 'clob'));
insert into t1 values (3), (1), (2), (4), (5);

select * from t1 order by 1;
select cast(e1 as char(10)) from t1 order by 1;
select cast(e1 as varchar) from t1 order by 1;
select cast(e1 as bit(16)) from t1 where e1=3 order by 1;
select cast(e1 as bit varying) from t1 where e1=4 order by 1;
select cast(cast(e1 as clob) as varchar) from t1 order by 1;

drop table t1;