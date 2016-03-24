--
create table tpr(i int)
partition by range (i)(
partition p_10 values less than (10),
partition p_20 values less than (20),
partition p_30 values less than (30),
partition p_100 values less than (100));

insert into tpr values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
insert into tpr select i + 10 from tpr;
insert into tpr select i + 20 from tpr;

create table t1 under tpr (j int);
insert into t1 values (-1, -1), (-2, -2), (-3, -3), (-4, -4), (-5, -5);

describe t1;

select * from t1 order by 1;
select * from tpr order by 1;
select * from all tpr order by 1;

drop table t1;
drop table tpr;
