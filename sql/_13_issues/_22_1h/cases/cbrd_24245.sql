-- USER NAME
create user [[u1]];
create user "[u1]";
create user `[u1]`;

-- TABLE NAME
create table [[t1]] (c1 int);
create table "[t1]" (c1 int);
create table `[t1]` (c1 int);

-- COLUMN NAME
create table t1 ([[c1]] int);
create table t1 ("[c1]" int);
create table t1 (`[c1]` int);

-- INDEX NAME
drop table if exists t1;
create table t1 (c1 int);
create index [[i1]] on t1 (c1);
create index "[i1]" on t1 (c1);
create index `[i1]` on t1 (c1);
drop table t1;

-- CONSTRAINT NAME
create table t1 (c1 int);
alter table t1 add constraint [[pk]] primary key (c1);
alter table t1 add constraint "[pk]" primary key (c1);
alter table t1 add constraint `[pk]` primary key (c1);
drop table t1;

-- RESOLUTION NAME
create table t1 (c1 int);
create table t2 under t1 inherit [[t1_c1]] of t1;
create table t2 under t1 inherit "[t1_c1]" of t1;
create table t2 under t1 inherit `[t1_c1]` of t1;
drop table t1;

-- PARTITION NAME
create table t1 (c1 varchar)
partition by list (c1) (
    partition [[l1]] values in ('one'),
    partition l2 values in ('two')
);
create table t1 (c1 varchar)
partition by list (c1) (
    partition "[l1]" values in ('one'),
    partition l2 values in ('two')
);
create table t1 (c1 varchar)
partition by list (c1) (
    partition `[l1]` values in ('one'),
    partition l2 values in ('two')
);

-- SERIAL NAME
create serial [[s1]];
create serial "[s1]";
create serial `[s3]`;

-- TRIGGER NAME
drop table if exists t2;
create table t1 (c1 int);
create table t2 (c1 int);
create trigger [[trig1]] after insert on t1 execute insert into t2 values (obj.c1);
create trigger "[trig1]" after insert on t1 execute insert into t2 values (obj.c1);
create trigger `[trig1]` after insert on t1 execute insert into t2 values (obj.c1);
drop table t2;
drop table t1;

-- ALIAS NAME
select 1 as [[c1]];
select 1 as "[c1]";
select 1 as `[c1]`;

-- CTE NAME
with [[w1]] as select 1
select * from w1;
with "[w1]" as select 1
select * from w1;
with `[w1]` as select 1
select * from w1;

-- PREPARE NAME
prepare [[p1]] from 'select 1';
deallocate prepare [[p1]];
prepare "[p1]" from 'select 1';
deallocate prepare "[p1]";
prepare `[p1]` from 'select 1';
deallocate prepare `[p1]`;

-- SESSION VARIABLE NAME
SET @[[v1]] = 'a';
SET @"[v1]" = 'a';
SET @`[v1]` = 'a';

-- FUNCTION NAME
create function [[sp]]() return varchar
as language java
name 'SpCubrid.Sp() return java.lang.String';

create function "[sp]"() return varchar
as language java
name 'SpCubrid.Sp() return java.lang.String';

create function `[sp]`() return varchar
as language java
name 'SpCubrid.Sp() return java.lang.String';
