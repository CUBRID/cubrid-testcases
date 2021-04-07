--+ holdcas on;

create table a (i int auto_increment primary key);

insert into a values(NULL);
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;

delete from a where i > 4000;

create table t (i int, j int, k int) partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200),
	partition p1600 values less than (1600),
	partition p2000 values less than (2000),
	partition p2400 values less than (2400),
	partition p2800 values less than (2800),
	partition p3200 values less than (3200),
	partition p3600 values less than (3600),
	partition p4000 values less than MAXVALUE
);

insert into t select i, i, i from a;
select count(i) from t;
select count(i) from t__p__p1600;

--select class_of.class_name, pname, pvalues from _db_partition order by pname;
--select class_of.class_name, pname, pvalues from _db_partition where pname = 'p1600' order by pname;
select class_name, partition_name, partition_values from db_partition order by partition_name;
select class_name, partition_name, partition_values from db_partition where partition_name = 'p1600' order by partition_name;



alter table t promote partition p1600;

select count(i) from t;

select count(i) from t__p__p1600;

--select class_of.class_name, pname, pvalues from _db_partition order by pname;
--select class_of.class_name, pname, pvalues from _db_partition where pname = 'p1600' order by pname;
select class_name, partition_name, partition_values from db_partition order by partition_name;
select class_name, partition_name, partition_values from db_partition where partition_name = 'p1600' order by partition_name;

select if (super_classes is null, 'ok', 'nok') from _db_class where class_name = 't__p__p1600';

alter table t promote partition p2000, p2400;

select if (super_classes is null, 'ok', 'nok') from _db_class where class_name = 't__p__p2000';
select if (super_classes is null, 'ok', 'nok') from _db_class where class_name = 't__p__p2400';


drop table t;

describe t__p__p1600;

drop table t__p__p1600;
drop table t__p__p2000;
drop table t__p__p2400;

create table t (i int, j int, k int) partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200),
	partition p1600 values less than (1600),
	partition p2000 values less than (2000),
	partition p2400 values less than (2400),
	partition p2800 values less than (2800),
	partition p3200 values less than (3200),
	partition p3600 values less than (3600),
	partition p4000 values less than MAXVALUE
);

insert into t select i, i, i from a;

alter table t promote partition p400, p800, p1200, p1600, p2000, p2400, p2800, p3200, p3600, p4000;

--select class_of.class_name, pname, pvalues from _db_partition order by pname;
select class_name, partition_name, partition_values from db_partition order by partition_name;

drop table t__p__p400;
drop table t__p__p800;
drop table t__p__p1200;
drop table t__p__p1600;
drop table t__p__p2000;
drop table t__p__p2400;
drop table t__p__p2800;
drop table t__p__p3200;
drop table t__p__p3600;
drop table t__p__p4000;

drop table t;

create table t (i int, j int, k int);

insert into t select i, i, i from a;

create index i_t_i on t(i);
create index i_t_i_j on t(i, j);
create index i_t_j_k on t(j, k);

alter table t partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200),
	partition p1600 values less than (1600),
	partition p2000 values less than (2000),
	partition p2400 values less than (2400),
	partition p2800 values less than (2800),
	partition p3200 values less than (3200),
	partition p3600 values less than (3600),
	partition p4000 values less than MAXVALUE
);

alter table t promote partition p3600;
update statistics on t;
show indexes from t;
update statistics on t__p__p3600;
show indexes from t__p__p3600;

drop table t;
drop table t__p__p3600;

create table t (i int, j int, k int,unique(i,j,k));

insert into t select i, i, i from a;

create index i_t_i on t(i);
create index i_t_i_j on t(i, j);
create index i_t_j_k on t(j, k);

alter table t partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200),
	partition p1600 values less than (1600),
	partition p2000 values less than (2000),
	partition p2400 values less than (2400),
	partition p2800 values less than (2800),
	partition p3200 values less than (3200),
	partition p3600 values less than (3600),
	partition p4000 values less than MAXVALUE
);

update statistics on t with fullscan;
show indexes from t;
update statistics on t__p__p3600 with fullscan;
show indexes from t__p__p3600;

alter table t promote partition p3600;

update statistics on t with fullscan;
show indexes from t;
update statistics on t__p__p3600 with fullscan;
show indexes from t__p__p3600;

drop table t;
drop table t__p__p3600;

create table t (i int, j int, k int,primary key(i,j));

insert into t select i, i, i from a;

create index i_t_i on t(i);
create index i_t_j_k on t(j, k);

alter table t partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200),
	partition p1600 values less than (1600),
	partition p2000 values less than (2000),
	partition p2400 values less than (2400),
	partition p2800 values less than (2800),
	partition p3200 values less than (3200),
	partition p3600 values less than (3600),
	partition p4000 values less than MAXVALUE
);
update statistics on t with fullscan;
show indexes from t;
update statistics on t__p__p3600 with  fullscan;
show indexes from t__p__p3600;

alter table t promote partition p3600;

update statistics on t with fullscan;
show indexes from t;
update statistics on t__p__p3600 with fullscan;
show indexes from t__p__p3600;

drop table t;
drop table t__p__p3600;

drop table a;

commit;
--+ holdcas off;
