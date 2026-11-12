-- Work456/08: complete independently modeled mixed-row schema values through JDBC.
-- Actual record and attribute placement belongs to the SA/CS shell companions.

drop table if exists oos08_rewrite;
create table oos08_rewrite(id int primary key,note int,payload bit varying storage prefer_inline);
insert into oos08_rewrite values(2,202,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(1,101,X'19ab23cd45ef');
select count(*) as n,sum(case when id=1 and note=101 and payload=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite add meta int after id;
select count(*) as n,sum(case when id=1 and note=101 and payload=X'19ab23cd45ef' and (meta is null) then 1 when id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (meta is null) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite drop meta;
select count(*) as n,sum(case when id=1 and note=101 and payload=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite change payload payload bit varying first;
select count(*) as n,sum(case when id=1 and note=101 and payload=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and payload=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite change payload body bit varying after note;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite modify body bit varying(60000) not null;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite modify note bigint;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
select count(*) as n from db_attribute where class_name='oos08_rewrite' and attr_name='note' and data_type='BIGINT';
alter table oos08_rewrite change note note int;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (1=1) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (1=1) then 1 else 0 end) as exact_rows from oos08_rewrite;
select count(*) as n from db_attribute where class_name='oos08_rewrite' and attr_name='note' and data_type='INTEGER';
alter table oos08_rewrite add tag int not null default 77;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (tag=77) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (tag=77) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite alter column tag set default 88;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (tag=77) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (tag=77) then 1 else 0 end) as exact_rows from oos08_rewrite;
insert into oos08_rewrite(id,note,body) values(3,303,X'19ab23cd45ef');
select count(*) as n from oos08_rewrite where id=3 and note=303 and body=X'19ab23cd45ef' and tag=88;
delete from oos08_rewrite where id=3;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (tag=77) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (tag=77) then 1 else 0 end) as exact_rows from oos08_rewrite;
set system parameters 'add_column_update_hard_default=yes';
alter table oos08_rewrite add hard int not null;
select count(*) as n,sum(case when id=1 and note=101 and body=X'19ab23cd45ef' and (tag=77 and hard=0) then 1 when id=2 and note=202 and body=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and (tag=77 and hard=0) then 1 else 0 end) as exact_rows from oos08_rewrite;
alter table oos08_rewrite drop body;
select count(*) as n,sum(case when id=1 and note=101 and tag=77 and hard=0 then 1 when id=2 and note=202 and tag=77 and hard=0 then 1 else 0 end) as exact_rows from oos08_rewrite;
set system parameters 'add_column_update_hard_default=no';
drop table oos08_rewrite;
