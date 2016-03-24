create table t1(id int) partition by range(id)
(partition l5 values less than (5),
partition l10 values less than (10),
partition l100 values less than (100),
partition lar values less than maxvalue);
insert into t1 select rownum from db_class limit 40;
insert into t1 select rownum+40 from t1;
insert into t1 select rownum+80 from t1;

alter table t1 reorganize partition l100,lar into (partition lar values less than maxvalue);
insert into t1 values (99),(100),(101);
select count(id) from t1__p__lar where id=99;
select count(id) from t1__p__lar where id=100;
select count(id) from t1__p__lar where id=101;

alter table t1 reorganize partition lar into (partition p1 values less than(20),partition p2 values less than (99),partition p3 values less than(101),partition p4 values less than maxvalue);
select * from t1__p__p1 where id >=20 order by 1;
select * from t1__p__p2 where id >=99 order by 1;
select * from t1__p__p3 where id in (98,99,100,101,102) order by 1;
select * from t1__p__p4 where id in (98,99,100,101,102) order by 1;

create table t2(id int) partition by range(id)
(partition l5 values less than (5),
partition l10 values less than (10),
partition l100 values less than (100),
partition lar values less than (1000));

insert into t2 select rownum from db_class limit 40;
insert into t2 select rownum+100 from t2;
insert into t2 select rownum+800 from t2;

alter table t2 reorganize partition l100,lar into (partition lar values less than (1000));
insert into t2 values(99),(100),(101);
alter table t2 reorganize partition lar into (partition lar values less than maxvalue);
alter table t2 reorganize partition l10,lar into (partition lar values less than maxvalue);
select * from t2__p__lar where id in (5,6,7,11,99,100,101,880) order by 1;

drop t1;
drop t2;

create table t1(id int) partition by range(id)
(partition l5 values less than (5),
partition l10 values less than (10),
partition l100 values less than (100),
partition lar values less than maxvalue);
insert into t1 select rownum from db_class limit 40;
insert into t1 select rownum+40 from t1;
insert into t1 select rownum+80 from t1;

alter table t1 promote partition l100;
alter table t1 reorganize partition l100,lar into (partition lar values less than maxvalue);
alter table t1 reorganize partition l10,lar into (partition lar values less than maxvalue);
insert into t1 values(9),(10),(11),(100);
select * from t1__p__lar where id in (9,10,11,100,101) order by 1;

drop t1;
drop t1__p__l100;

