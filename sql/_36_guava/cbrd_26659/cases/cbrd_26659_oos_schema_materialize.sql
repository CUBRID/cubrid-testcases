-- JIRA4774943: source-confirmed ALTER materialization; SQL logical evidence.
-- ADD NOT NULL without DEFAULT generates UPDATE ALL (execute_schema.c).
-- Literal ADD DEFAULT, failed hard-default ADD and successful hard-default ADD
-- have separately asserted values/catalog. schema_sa/schema_cs observe placement.
drop table if exists oos08_materialize;
drop table if exists oos08_alter_grow;
set system parameters 'add_column_update_hard_default=no';
create table oos08_materialize(id int primary key,a bit varying,b bit varying,note varchar(20));
insert into oos08_materialize values(1,cast(repeat('a1',5000) as bit varying),cast(repeat('b2',4600) as bit varying),'base');
select count(*) as n,min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5,min(md5(b)) as b_md5 from oos08_materialize;
alter table oos08_materialize add literal_col int not null default 77;
select count(*) as n,min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and literal_col=77 then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5,min(md5(b)) as b_md5 from oos08_materialize;
select count(*) as literal_catalog from db_attribute where class_name='oos08_materialize' and attr_name='literal_col' and data_type='INTEGER' and is_nullable='NO' and default_value='77';
set system parameters 'add_column_update_hard_default=yes';
alter table oos08_materialize add hard_col int not null;
select count(*) as n,min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and literal_col=77 and hard_col=0 then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5,min(md5(b)) as b_md5 from oos08_materialize;
select count(*) as hard_catalog from db_attribute where class_name='oos08_materialize' and attr_name='hard_col' and data_type='INTEGER' and is_nullable='NO' and default_value is null;
select count(*) as substituted from oos08_materialize where a=cast(repeat('b2',5000) as bit varying) or b=cast(repeat('b2',4599)||'00' as bit varying);
create table oos08_alter_grow(id int primary key,a bit varying);
insert into oos08_alter_grow values(1,cast(repeat('d4',3000) as bit varying));
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) then 1 else 0 end) as exact_ok from oos08_alter_grow;
alter table oos08_alter_grow add grow_data bit varying not null default cast(repeat('e5',2500) as bit varying);
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) and grow_data=cast(repeat('e5',2500) as bit varying) then 1 else 0 end) as exact_ok from oos08_alter_grow;
set system parameters 'add_column_update_hard_default=no';
alter table oos08_alter_grow add blocked int not null;
select count(*) as blocked_catalog from db_attribute where class_name='oos08_alter_grow' and attr_name='blocked';
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) and grow_data=cast(repeat('e5',2500) as bit varying) then 1 else 0 end) as exact_ok from oos08_alter_grow;
set system parameters 'add_column_update_hard_default=yes';
alter table oos08_alter_grow add hard_col int not null;
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) and grow_data=cast(repeat('e5',2500) as bit varying) and hard_col=0 then 1 else 0 end) as exact_ok from oos08_alter_grow;
select count(*) as hard_catalog from db_attribute where class_name='oos08_alter_grow' and attr_name='hard_col' and data_type='INTEGER' and is_nullable='NO' and default_value is null;
set system parameters 'add_column_update_hard_default=no';
drop table oos08_alter_grow;
drop table oos08_materialize;
