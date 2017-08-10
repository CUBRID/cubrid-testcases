create table t(i int) partition by hash(i) partitions 122;
insert into t select rownum from db_class limit 39;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;

alter table t remove partitioning;
rename table t as t2;
alter table t2 partition by hash(i) partitions 50;
alter table t2 add partition partitions 24;
alter table t2 remove partitioning;
alter table t2 partition by range(i) (
partition p0 values less than (1),
partition p1 values less than (2),
partition p2 values less than (3),
partition p3 values less than (4),
partition p4 values less than (5),
partition p5 values less than (6),
partition p6 values less than (7),
partition p7 values less than (8),
partition p8 values less than (9),
partition p9 values less than (10),
partition p10 values less than (11),
partition p11 values less than (12),
partition p12 values less than (13),
partition p13 values less than (14),
partition p14 values less than (15),
partition p15 values less than (16),
partition p16 values less than (17),
partition p17 values less than (18),
partition p18 values less than (19),
partition p19 values less than (20),
partition p20 values less than (21),
partition p21 values less than (22),
partition p22 values less than (23),
partition p23 values less than (24),
partition p24 values less than (25),
partition p25 values less than (26),
partition p26 values less than (27),
partition p27 values less than (28),
partition p28 values less than (29),
partition p29 values less than (30),
partition p30 values less than (31),
partition p31 values less than (32),
partition p32 values less than (33),
partition p33 values less than (34),
partition p34 values less than (35),
partition p35 values less than (36),
partition p36 values less than (37),
partition p37 values less than (38),
partition p38 values less than (39),
partition p39 values less than (40));
alter table t2 promote partition p33,p32,p14,p22;
alter table t2 drop partition p31;
alter table t2 remove partitioning;

drop t2;
drop t2__p__p33,t2__p__p32,t2__p__p14,t2__p__p22;