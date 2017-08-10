set system parameters 'dont_reuse_heap_file=yes';
drop table if exists aaa;
drop table if exists bbb;
drop table if exists ccc;
drop table if exists ddd;
drop table if exists eee;
create table aaa (id int primary key);
create table bbb (id int primary key, key1 int, key2 int);
create table ccc (id int );
create table ddd (key1 int , nm varchar(200));
create table eee (key1 int primary key, nm varchar(200));
insert into aaa values(1), (2), (3);
insert into bbb values(1, 1, 1), (2, 2, 2), (3, 3, 3);
insert into ccc values(1), (2), (3);
insert into ddd values(1, '111'), (2, '222'), (3, '333');
insert into eee values(1, '111'), (2, '222'), (3, '333');
UPDATE STATISTICS ON all classes;
select /*+ recompile */ eee.nm, ddd.nm
from aaa
, bbb
left outer join ccc on bbb.id = ccc.id
left outer join ddd on bbb.key2 = ddd.key1
,eee
where aaa.id = bbb.id
and bbb.key1 = eee.key1
and (ddd.nm = 'aaa' or eee.nm = 'bbb')
and aaa.id = 1;


select /*+ recompile */ eee.nm, ddd.nm
from aaa
, bbb
left outer join ccc on bbb.id = ccc.id
left outer join ddd on bbb.key2 = ddd.key1
,eee
where aaa.id = bbb.id
and bbb.key1 = eee.key1
and (ddd.nm = 'aaa' or eee.nm = 'bbb')
and aaa.id = 1 using index none;
drop table if exists aaa;
drop table if exists bbb;
drop table if exists ccc;
drop table if exists ddd;
drop table if exists eee;
set system parameters 'dont_reuse_heap_file=no';
