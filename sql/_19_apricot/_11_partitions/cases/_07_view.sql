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

create view vpr1 as select * from tpr where i >12;
select * from vpr1 where i % 2 = 0;

create view vpr_10_1 as select * from tpr__p__p_10 where i % 2 = 0;
select * from vpr_10_1;

drop view vpr1;
drop view vpr_10_1;
drop table tpr;
