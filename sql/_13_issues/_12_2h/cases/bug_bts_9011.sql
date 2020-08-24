set system parameters 'create_table_reuseoid=no';
create table tpr(i int) partition by list (i)(
	partition p6 values in (1,2,3,4,5),
	partition p10 values in (6,7,8,9,10),
	partition p15 values in (11,12,13,14,15),
	partition p19 values in (16,17,18,19),
	partition p20 values in (20)
);

insert into tpr values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

insert into tpr select i + 10 from tpr;

create view v1 as select * from tpr where i>9 with check option;

select * from v1 order by 1;

alter table tpr promote partition p20;

drop tpr__p__p20;

select * from v1 order by 1;

update v1 set i=i+1 where i>12 and i<19;

update v1 set i=i+1 where i = 15;

drop view v1;
drop tpr;

create table t(i int) partition by list (i)(
	partition p0 values in (1,2,3,4,5),
	partition p1 values in (6,7,8,9,10),
	partition p2 values in (11,12,13,14,15),
	partition p3 values in (16,17,18,19)
);

insert into t select rownum from _db_class limit 19;

create table a(col t);

create trigger trg_bef_update_t before update on t execute insert into a values (new);

create trigger trg_after_update_t after update on t execute insert into a values (obj);

update t set i = 11 where i = 10;

update t set i = 16 where i = 15;

select a.col.i from a order by 1;

drop table t;
drop table a;

create table t(i int) partition by list (i)(
	partition p0 values in (1,2,3,4,5),
	partition p1 values in (6,7,8,9,10),
	partition p2 values in (11,12,13,14,15),
	partition p3 values in (16,17,18,19)
);

insert into t select rownum from _db_class limit 19;

create table a(i int);

create trigger trg_bef_update_t before update on t execute insert into a values (obj.i);

create trigger trg_after_update_t after update on t execute insert into a values (obj.i);

update t set i = 11 where i = 10;

update t set i = 16 where i = 15;

select a.i from a order by 1;

drop table t;
drop table a;

create table tt(i int) partition by range(i) (partition p0 values less than(3));
insert into tt values(1),(2);
create view vv as select * from tt;
update vv set i=i+1;

drop tt;
drop vv;
set system parameters 'create_table_reuseoid=yes';
