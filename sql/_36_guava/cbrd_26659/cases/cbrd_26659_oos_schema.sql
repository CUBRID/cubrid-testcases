-- JIRA4774943 logical schema regression through JDBC. Physical placement is observed
-- separately by schema_sa/schema_cs. Literal DEFAULT is not ALTER rewrite evidence.
-- Expected values/catalog and lower-case hex-string MD5s are independently authored.

drop table if exists oos08_schema;
drop table if exists oos08_grow;
create table oos08_schema (id int primary key,a bit varying,b bit varying,note varchar(20),keep_col int);
insert into oos08_schema values(1,cast(repeat('a1',5000) as bit varying),cast(repeat('b2',4600) as bit varying),'base',10);
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema change b b bit varying first;
alter table oos08_schema change a a bit varying after note;
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
select attr_name,def_order from db_attribute where class_name='oos08_schema' order by def_order;
alter table oos08_schema add meta_only varchar(20) after id;
select count(*) as meta_catalog from db_attribute where class_name='oos08_schema' and attr_name='meta_only' and def_order=2 and data_type='STRING' and prec=20 and is_nullable='YES';
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and keep_col=10 and meta_only is null then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema drop meta_only;
select count(*) as removed_meta from db_attribute where class_name='oos08_schema' and attr_name='meta_only';
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='base' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema add rewrite_data bit varying after b;
select count(*) as data_catalog from db_attribute where class_name='oos08_schema' and attr_name='rewrite_data' and def_order=1 and data_type='VARBIT' and is_nullable='YES';
update oos08_schema set rewrite_data=cast(repeat('c3',1200) as bit varying),note='rewrite' where id=1;
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='rewrite' and keep_col=10 and rewrite_data=cast(repeat('c3',1200) as bit varying) then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema drop rewrite_data;
select count(*) as removed_data from db_attribute where class_name='oos08_schema' and attr_name='rewrite_data';
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='rewrite' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema modify a bit varying(50000) not null;
alter table oos08_schema modify note varchar(40);
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='rewrite' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
select attr_name,prec,is_nullable from db_attribute where class_name='oos08_schema' and attr_name in ('a','note') order by attr_name;
alter table oos08_schema modify a int storage default;
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='rewrite' and keep_col=10 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
select count(*) as schema_ok from db_attribute where class_name='oos08_schema' and attr_name='a' and prec=50000 and is_nullable='NO' and data_type='VARBIT';
set system parameters 'add_column_update_hard_default=yes';
alter table oos08_schema add default_col int not null default 77 after keep_col;
select count(*) as literal_catalog from db_attribute where class_name='oos08_schema' and attr_name='default_col' and def_order=5 and data_type='INTEGER' and is_nullable='NO' and default_value='77';
select count(*) as n, min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and b=cast(repeat('b2',4600) as bit varying) and note='rewrite' and keep_col=10 and default_col=77 then 1 else 0 end) as exact_ok, min(md5(a)) as a_md5, min(md5(b)) as b_md5 from oos08_schema;
alter table oos08_schema drop b;
select count(*) as n,min(case when id=1 and a=cast(repeat('a1',5000) as bit varying) and note='rewrite' and keep_col=10 and default_col=77 then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5 from oos08_schema;
select count(*) as dropped_attribute from db_attribute where class_name='oos08_schema' and attr_name='b';
select count(*) as surviving_attributes,sum(case when (attr_name='id' and data_type='INTEGER' and is_nullable='NO') or (attr_name='a' and data_type='VARBIT' and prec=50000 and is_nullable='NO') or (attr_name='note' and data_type='STRING' and prec=40 and is_nullable='YES') or (attr_name='keep_col' and data_type='INTEGER' and is_nullable='YES') or (attr_name='default_col' and data_type='INTEGER' and default_value='77' and is_nullable='NO') then 1 else 0 end) as surviving_metadata from db_attribute where class_name='oos08_schema';
create table oos08_grow(id int primary key,a bit varying);
insert into oos08_grow values(1,cast(repeat('d4',3000) as bit varying));
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) then 1 else 0 end) as exact_ok from oos08_grow;
alter table oos08_grow add grow_data bit varying not null default cast(repeat('e5',2500) as bit varying);
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) and grow_data=cast(repeat('e5',2500) as bit varying) then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5,min(md5(grow_data)) as grow_md5 from oos08_grow;
-- Separate later UPDATE: this is the write that materializes the literal value.
update oos08_grow set grow_data=cast(repeat('e5',2500) as bit varying) where id=1;
select count(*) as n,min(case when id=1 and a=cast(repeat('d4',3000) as bit varying) and grow_data=cast(repeat('e5',2500) as bit varying) then 1 else 0 end) as exact_ok,min(md5(a)) as a_md5,min(md5(grow_data)) as grow_md5 from oos08_grow;
set system parameters 'add_column_update_hard_default=no';
drop table oos08_grow;
drop table oos08_schema;
