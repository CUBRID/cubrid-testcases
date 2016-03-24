--
create table t1(i int, e1 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') default 'Sunday');
insert into t1 values (1, default), (3, 3), (2, 'Monday'), (6, 'Friday'), (7, 7), (4, 4), (5, 5);
describe t1;

select * from t1 order by 1, 2;

insert into t1 (i) select i from t1 where e1 < 4;
select * from t1 order by 1, 2;

create table t2(e enum('a', 'b') default 'b') as select i % 2 + 1 from t1;
select * from t2 order by 1, 2;
describe t2;

create table t3 like t2;
describe t3;

drop table t1;
drop table t2;
drop table t3;
