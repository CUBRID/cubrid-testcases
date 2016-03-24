--Use max enum value in index
create table t1(e1 enum('Yes', 'No', 'Cancel'), e2 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));
insert into t1 values(1, 1), (3, 2), (1, 3), (3, 7), (2, 6), (3, 4), (2, 5);

create index idx1 on t1(e1, e2);
update statistics on t1;

select * from t1 where e1=1 and e2 > 1;

drop table t1;