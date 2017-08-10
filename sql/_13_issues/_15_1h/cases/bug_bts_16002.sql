--test: Core dumped when inserting into a range partition table with ODKU statement.


drop table if exists t;

create table t(
col1 int primary key
)
partition by range(col1) (
partition p1 values less than(10),
partition p2 values less than(20)
);

insert into t(col1) values(19);
insert into t(col1) values(19) on duplicate key update col1 = 5;
insert into t(col1) values(20) on duplicate key update col1 = 5;

select * from t order by 1;


drop table if exists t;

create table t(
col1 int primary key
)
partition by list(col1) (
partition p1 VALUES IN(1,3,5,7,9,10),
partition p2 VALUES IN(2,4,6,8,11)
);

insert into t(col1) values(11);
insert into t(col1) values(11) on duplicate key update col1 = 5;
insert into t(col1) values(20) on duplicate key update col1 = 5;

select * from t order by 1;


drop table t;
