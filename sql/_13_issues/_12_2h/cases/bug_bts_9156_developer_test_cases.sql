drop table if exists t;

create table t(i int) partition by range(i) (
	partition p0 values less than (10),
	partition p1 values less than (20),
	partition p2 values less than (30),
	partition p3 values less than (40),
	partition p4 values less than (50),
	partition p5 values less than (60),
	partition p6 values less than (70),
	partition p7 values less than (80),
	partition p8 values less than (90),
	partition p9 values less than (100)
);

create index i_t_i on t(i) where i < 100;

insert into t select rownum from db_class limit 50;

insert into t select 50+rownum from db_class limit 49;

select count(*) from t using index i_t_i(+);

alter table t promote partition p1, p3;

select count(*) from t using index i_t_i(+);

alter table t promote partition p5, p6, p9;

alter table t reorganize partition p2 into (partition p1_1 values less than(20), partition p2 values less than(30));
alter table t reorganize partition p4 into (partition p3_1 values less than(40), partition p4 values less than(50));

alter table t promote partition p0, p2, p4, p7, p8;

select count(i) from t using index i_t_i (+);

drop table t__p__p0;
drop table t__p__p1;
drop table t__p__p2;
drop table t__p__p3;
drop table t__p__p4;
drop table t__p__p5;
drop table t__p__p6;
drop table t__p__p7;
drop table t__p__p8;
drop table t__p__p9;

drop table if exists t;

