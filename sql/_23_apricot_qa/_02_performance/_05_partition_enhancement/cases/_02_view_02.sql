set system parameters 'create_table_reuseoid=no';
drop table if exists tpr;
drop table if exists tpr__p__p20;
drop table if exists tpr__P__p6;

create table tpr(i int)
partition by list (i)(
partition p6 values in (1,2,3,4,5),
partition p10 values in (6,7,8,9,10),
partition p15 values in (11,12,13,14,15),
partition p19 values in (16,17,18,19),
partition p20 values in (20));

insert into tpr values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
insert into tpr select i + 10 from tpr;

create view v1 as select * from tpr where i>9 with check option;
select * from v1 order by 1;
alter table tpr promote partition p20;
select * from v1 order by 1;
update v1 set i=i+1 where i>12 and i<19;
alter table tpr promote partition p6;
select * from v1 order by 1;


create view v2 as select * from tpr__p__p20 where i>=20 with check option;
select * from v2;
update v2 set i=16 where i=20;
insert into v2 values(21);
update v2 set i=20 where i=21;

drop tpr;
drop tpr__p__p20;
drop v1;
drop v2;
drop tpr__p__p6;
set system parameters 'create_table_reuseoid=yes';
