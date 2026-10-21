-- Work456/09: PK maintenance, UNIQUE build, full-tail keys, atomic errors.
-- VARBIT inputs are 5107 bytes, equal through byte5106 and different at tail.
-- All expected models/counts/errors are specified before the native run.
-- This JDBC case proves logical behavior only. The shell suite separately
-- observes its own actual indexed attributes; no cross-invocation flag claim.
-- Direct DML duplicate=-670; server NOT NULL=-631 at pinned product profile.

drop table if exists oos09_pk;

drop table if exists oos09_unique;

create table oos09_pk(id int,note int,k bit varying, constraint oos09_pk_key primary key(k)) dont_reuse_oid;

insert into oos09_pk values(1,101,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(2,202,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying));

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

select id,case when k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end as full_key from oos09_pk where k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) using index oos09_pk_key(+);

select id,case when (id=1 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end as full_key from oos09_pk where k between cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) and cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) using index oos09_pk_key(+) order by k;

insert into oos09_pk values(3,303,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

update oos09_pk set note=999,k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) where id=2;

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

insert into oos09_pk values(3,303,cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying)),(4,404,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

insert into oos09_pk values(3,303,NULL);

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

autocommit off;

update oos09_pk set k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying),note=303 where id=1;

delete from oos09_pk where id=2;

insert into oos09_pk values(4,404,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n,sum(case when id=1 and note=303 and k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying) then 1 when id=4 and note=404 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

rollback;

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos09_pk;

autocommit on;

create table oos09_unique(id int,note int,k bit varying storage force_outline) dont_reuse_oid;

insert into oos09_unique values(1,101,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(2,202,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)),(3,303,NULL),(4,404,NULL);

alter table oos09_unique add constraint oos09_unique_key unique(k);

select count(*) as n,sum(case when id=1 and note=101 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying) then 1 when id=2 and note=202 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 when id=3 and note=303 and k is null then 1 when id=4 and note=404 and k is null then 1 else 0 end) as exact_rows from oos09_unique;

insert into oos09_unique values(5,505,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying));

update oos09_unique set k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying),note=505 where id=2;

select id,case when k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying) and note=505 then 1 else 0 end as full_key from oos09_unique where k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying) using index oos09_unique_key(+);

delete from oos09_unique where k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying);

select count(*) as deleted_key from oos09_unique where k=cast(concat(repeat('d4',1801),repeat('e5',1803),repeat('f6',1803)) as bit varying) using index oos09_unique_key(+);

drop table oos09_unique;

drop table oos09_pk;

select count(*) as fixture_tables from db_class where class_name in ('oos09_pk','oos09_unique');
