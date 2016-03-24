--test with ddl


create table sp_ddl(id1 bigint, col1 time not null, primary key(id1, col1))
partition by range(col1)
(partition p0 values less than (time'12:12:13'),
partition p1 values less than (time'12:12:15'),
partition p2 values less than (time'12:12:18'));

insert into sp_ddl values(1000000, '12:12:12'), (2000000, '12:12:13'), (3000000, '12:12:14'), (4000000, '12:12:15'), (5000000, '12:12:16'), (6000000, '12:12:17'), (7000000, '12:12:15');


--TEST: create table like
create table foo like sp_ddl partition (p1);
drop table if exists foo;

--TEST: create table as select
create table foo as select * from sp_ddl partition (p1);
select * from foo order by 1;
drop table if exists foo;

--TEST: [er] add column
alter table sp_ddl partition (p0) add column col2 char(10);

--TEST: [er] add constraint
alter table sp_ddl partition (p1) add unique u_key(id1);

--TEST: [er] add index
alter sp_ddl partition (p2) add index i(col1);

--TEST: [er] alter column ... set default
alter sp_ddl partition (p0) add column col1 set default '1:1:1';

--TEST: [er] change
alter table sp_ddl partition (p1) change col1 aaa char(100);

--TEST: [er] modify
alter table sp_ddl partition (p2) modify col1 char(100) unique;

--TEST: [er] rename column
alter table sp_ddl partition (p0) rename column col1 as bbb;

--TEST: [er] drop column
alter table sp_ddl partition (p1) drop column id1, col1;

--TEST: [er] drop constraint
alter table sp_ddl partition (p2) drop constraint pk_sp_ddl_id1;

--TEST: [er] drop index
alter table sp_ddl partition (p0) drop index pk_sp_ddl_id1;

--TEST: [er] drop primary key
alter table sp_ddl partition (p1) drop primary key;

--TEST: rename table
rename table sp_ddl partition (p0) as sp_ddl partition (p111);

--TEST: create view
create view v1 as select * from sp_ddl partition (p0) where id1 < 2000000;
select * from v1 order by 1;
create view v2 as select * from sp_ddl partition (p0) where id1 < 2000000 with check option;
select * from v2 order by 2;

drop view v1;
drop view v2;

--TEST: [er] drop table
drop sp_ddl partition (p2);

--TEST: show columns, desc
show columns in sp_ddl partition (p0);
desc sp_ddl partition (p1);

--TEST: truncate
truncate sp_ddl partition (p1);


drop table sp_ddl;
