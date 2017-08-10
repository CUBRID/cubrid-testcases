drop table if exists t;
drop table if exists t__p__p1,t__p__p2;
create table t(i int) partition by list(i) (
    partition p0 values in (1, 2, 3),
    partition p1 values in (4, 5, 6),
    partition p2 values in (7, 8, 9),
    partition p3 values in (10, 11, 12)
);

create index i_t_i on t(i) where i<10;
ALTER TABLE t PROMOTE PARTITION p1, p2;
drop table if exists t;
drop table if exists t__p__p1,t__p__p2;
