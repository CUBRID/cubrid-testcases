-- SET WITH DEDUPLICATE OPTION TO SHOW
set system parameters 'print_index_detail=y';
set system parameters 'deduplicate_key_level=0';

-- Modify column with compatible type change on single column index and deduplicate option
create table [tbl] ([id] integer not null, [val] character varying(2000));
insert into tbl select rownum, rownum from db_class a, db_class b limit 100;
create index ix_val on tbl(val);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, func, index_of.filter_expression FROM _db_index_key WHERE index_of.index_name = 'ix_val';
desc tbl;
alter table tbl modify column val int;
desc tbl;
drop index ix_val on tbl;
create index ix_val_de02 on tbl(val) with deduplicate=2;
alter table tbl modify column val varchar(2000);
desc tbl;

-- Check index data type has been changed when the column data type is modified.
SELECT k.index_of.class_of.class_name, k.index_of.index_name, k.key_attr_name, k.key_order, k.asc_desc, (select t.type_name from _db_attribute a, _db_data_type t where a.data_type = t.type_id and a.class_of.class_name = index_of.class_of.class_name and a.attr_name = k.key_attr_name) data_type
FROM _db_index_key k WHERE index_of.index_name = 'ix_val_de02';

-- Modify column with compatible type change on composite column index and deduplicate option
drop table if exists tbl;
create table [tbl] ([id] integer not null, [val] character varying(2000), [val2] int);
insert into tbl select rownum, rownum, rownum from db_class a, db_class b limit 100;
create index ix_val on tbl(val, val2);
alter table tbl change column val val1 int;  -- type and column name change
desc tbl;
drop index ix_val on tbl;
create index ix_val_de02 on tbl(val1, val2) with deduplicate=2;
alter table tbl modify column val1 varchar(2000);
desc tbl;
alter table tbl change column val1 val0 int;  -- type and column name change with deduplicated index
desc tbl;
-- Check index data type has been changed when the column data type is modified.
SELECT k.index_of.class_of.class_name, k.index_of.index_name, k.key_attr_name, k.key_order, k.asc_desc, (select t.type_name from _db_attribute a, _db_data_type t where a.data_type = t.type_id and a.class_of.class_name = index_of.class_of.class_name and a.attr_name = k.key_attr_name) data_type
FROM _db_index_key k WHERE index_of.index_name = 'ix_val_de02';

-- Modify column with compatible type change on deduplicate single column filtered index
drop table if exists tbl;
create table [tbl] ([id] integer not null, [val] character varying(2000));
insert into tbl select rownum, rownum from db_class a, db_class b limit 100;
create index ix_val on tbl(val) where val < 50;
alter table tbl modify column val int;
show create table tbl;
drop index ix_val on tbl;
create index ix_val_de02 on tbl(val) where val < 50 with deduplicate=2;
alter table tbl modify column val varchar(2000);
show create table tbl;
-- Check index data type has been changed when the column data type is modified.
SELECT k.index_of.class_of.class_name, k.index_of.index_name, k.key_attr_name, k.key_order, k.asc_desc, (select t.type_name from _db_attribute a, _db_data_type t where a.data_type = t.type_id and a.class_of.class_name = index_of.class_of.class_name and a.attr_name = k.key_attr_name) data_type
FROM _db_index_key k WHERE index_of.index_name = 'ix_val_de02';


-- Modify column with compatible type change on deduplicate single column index on partitioned table
drop table if exists tbl;
-- range partition
create table [tbl] ([id] integer not null, [val] character varying(2000))
partition by range(id) (partition below_50 values less than (50)); 
create index ix_val_de02 on tbl(val) with deduplicate=2;
insert into tbl select rownum, rownum from db_class a, db_class b limit 0,49;
alter table tbl add partition (partition over_50 VALUES LESS THAN MAXVALUE);
insert into tbl select rownum, rownum from db_class a, db_class b limit 49,51;
show create table tbl;
alter table tbl modify column val int;
show create table tbl;

-- list partition with composite index
drop table if exists tbl;
create table [tbl] ([id] integer not null, [val] character varying(2000), [val2] int) partition by list (val) (partition tv_null values in (NULL),partition tv_zero values in ('0'),partition tv_one values in ('1'));
insert into tbl select rownum, case rownum%3 when 0 then '0' when '1' then '1' else null end, rownum from db_class a, db_class b limit 100;
create index ix_val_de02 on tbl(val,val2) with deduplicate=2;
show create table tbl;
alter table tbl modify column val varchar(2000);
show create table tbl;

-- hash partition
drop table if exists tbl;
create table [tbl] ([id] integer not null, [val] character varying(2000))
partition by hash (id) partitions 3;
create index ix_val_de02 on tbl(val) with deduplicate=2;
insert into tbl select rownum, rownum from db_class a, db_class b limit 100;
show create table tbl;
alter table tbl modify column val int;
show create table tbl;

drop table if exists tbl;
set system parameters 'print_index_detail=n';
set system parameters 'deduplicate_key_level=-1';
