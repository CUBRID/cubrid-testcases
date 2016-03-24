drop table if exists tpr;
drop table if exists t1;
drop table if exists tpr__p__p_20;
drop table if exists tpr__p__p_10;
drop table if exists tpr__p__p_30;
drop table if exists tpr__p__p_100;

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

select * from all tpr order by 1;

alter table tpr promote partition p_20;
select * from all tpr order by 1;
select if (super_classes is null,'yes','no') result from _db_class where class_name = 'tpr__p__p_20';
select if (sub_classes is null,'yes','no') result from _db_class where class_name = 'tpr__p__p_20';

alter table tpr promote partition t1;

alter table tpr promote partition p_10,p_100,p_30;
select * from all tpr order by 1;
select if (sub_classes is null,'yes','no') result from _db_class where class_name = 'tpr';
drop table t1;
drop table tpr;

create table t1 under tpr__p__p_20 (i int);
select * from all tpr__p__p_20 order by 1;
select if (super_classes is null,'yes','no') result from _db_class where class_name ='t1';
select if (sub_classes is null,'yes','no') result from _db_class where class_name = 'tpr__p__p_20';
drop tpr__p__p_20;
select * from all tpr__p__p_20 order by 1;
drop t1;

create table t1 under tpr__p__p_10(j int);
insert into t1 values(-1,-1);
alter table tpr__p__p_10 partition by range(i) (partition p0 values less than(10),partition p1 values less than maxvalue);
insert into tpr__p__p_10 values(100);
select * from all tpr__p__p_10 order by 1;
drop tpr__p__p_10;
select * from t1;
drop t1;
drop tpr__p__p_30;
drop tpr__p__p_100;








