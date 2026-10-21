-- Work456/10: independently specified FK semantics through native JDBC.
-- Actual record flags/ownership belong to separate shell invocations.
-- Manual table_stmt FK contract; generic public FK answers establish errors.

drop table if exists oos10_c;

drop table if exists oos10_p;

create table oos10_p(id int,note int,tenant int,k bit varying,constraint oos10_pk primary key(k)) dont_reuse_oid;

create table oos10_c(id int,note int,tenant int,k bit varying,constraint oos10_fk foreign key(k) references oos10_p(k) on delete cascade);

insert into oos10_p values(1,101,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(2,202,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying));

insert into oos10_c values(11,111,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(12,222,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(13,333,NULL,NULL);

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(90,999,7,cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(91,999,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)),(92,999,7,cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

update oos10_c set k=cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying),note=999 where id=11;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_p values(90,999,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

delete from oos10_p where id=1;

select count(*) as n,sum(case when id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when id=13 and note=333 and tenant is null and k is null then 1 else 0 end) as exact_rows from oos10_c;

drop table oos10_c;

drop table oos10_p;

drop table if exists oos10_c;

drop table if exists oos10_p;

create table oos10_p(id int,note int,tenant int,k bit varying,constraint oos10_pk primary key(tenant,k)) dont_reuse_oid;

create table oos10_c(id int,note int,tenant int,k bit varying,constraint oos10_fk foreign key(tenant,k) references oos10_p(tenant,k) on update set null);

insert into oos10_p values(1,101,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(2,202,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying));

insert into oos10_c values(11,111,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(12,222,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)),(13,333,NULL,NULL);

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(90,999,7,cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(91,999,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)),(92,999,7,cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

update oos10_c set k=cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying),note=999 where id=11;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_p values(90,999,7,cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=2 and note=202 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1702),'c4') as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=12 and note=222 and tenant=7 and k=cast(concat(repeat('a1',1701),repeat('b2',1703),repeat('c3',1703)) as bit varying)) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

update oos10_p set k=cast(concat(repeat('d4',1701),repeat('e5',1703),repeat('f6',1703)) as bit varying) where id=1;

select count(*) as n,sum(case when (id=11 and note=111 and tenant is null and k is null) or (id=12 and note=222 and tenant is null and k is null) or (id=13 and note=333 and tenant is null and k is null) then 1 else 0 end) as exact_rows from oos10_c;

drop table oos10_c;

drop table oos10_p;

drop table if exists oos10_c;

drop table if exists oos10_p;

create table oos10_p(id int,note int,tenant int,k int,v bit varying,constraint oos10_pk primary key(k)) dont_reuse_oid;

create table oos10_c(id int,note int,tenant int,k int,v bit varying,constraint oos10_fk foreign key(k) references oos10_p(k) on delete set null);

insert into oos10_p values(1,101,7,101,cast(repeat('a1',5107) as bit varying)),(2,202,7,202,cast(repeat('b2',5107) as bit varying));

insert into oos10_c values(11,111,7,101,cast(repeat('a1',5107) as bit varying)),(12,222,7,101,cast(repeat('b2',5107) as bit varying)),(13,333,NULL,NULL,X'01');

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(90,999,7,303,cast(repeat('a1',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(91,999,7,202,cast(repeat('a1',5107) as bit varying)),(92,999,7,303,cast(repeat('b2',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

update oos10_c set k=303,note=999 where id=11;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_p values(90,999,7,101,cast(repeat('a1',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

delete from oos10_p where id=1;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k is null and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k is null and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

drop table oos10_c;

drop table oos10_p;

drop table if exists oos10_c;

drop table if exists oos10_p;

create table oos10_p(id int,note int,tenant int,k int,v bit varying,constraint oos10_pk primary key(tenant,k)) dont_reuse_oid;

create table oos10_c(id int,note int,tenant int,k int,v bit varying,constraint oos10_fk foreign key(tenant,k) references oos10_p(tenant,k) on delete no action on update no action);

insert into oos10_p values(1,101,7,101,cast(repeat('a1',5107) as bit varying)),(2,202,7,202,cast(repeat('b2',5107) as bit varying));

insert into oos10_c values(11,111,7,101,cast(repeat('a1',5107) as bit varying)),(12,222,7,101,cast(repeat('b2',5107) as bit varying)),(13,333,NULL,NULL,X'01');

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(90,999,7,303,cast(repeat('a1',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_c values(91,999,7,202,cast(repeat('a1',5107) as bit varying)),(92,999,7,303,cast(repeat('b2',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

update oos10_c set k=303,note=999 where id=11;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

insert into oos10_p values(90,999,7,101,cast(repeat('a1',5107) as bit varying));

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

delete from oos10_p where id=1;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

update oos10_p set k=303 where id=1;

select count(*) as n,sum(case when (id=1 and note=101 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=2 and note=202 and tenant=7 and k=202 and v=cast(repeat('b2',5107) as bit varying)) then 1 else 0 end) as exact_rows from oos10_p;

select count(*) as n,sum(case when (id=11 and note=111 and tenant=7 and k=101 and v=cast(repeat('a1',5107) as bit varying)) or (id=12 and note=222 and tenant=7 and k=101 and v=cast(repeat('b2',5107) as bit varying)) or (id=13 and note=333 and tenant is null and k is null and v=X'01') then 1 else 0 end) as exact_rows from oos10_c;

drop table oos10_c;

drop table oos10_p;

create table oos10_p(k bit varying primary key) dont_reuse_oid;

create table oos10_bad(k bit varying,foreign key(k) references oos10_p(k) on update cascade);

select count(*) as n,count(*) as exact_rows from db_class where class_name='oos10_bad';

drop table oos10_p;
