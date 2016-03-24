-- CREATE ( LIKE );

create table tab1(i integer);
create table tab1b (like tab1);

drop table tab1;
drop table tab1b;


create table tab1(i integer);
create index idx  on tab1(i);
create table tab1b (like tab1);

drop table tab1;
drop table tab1b;


-- create-like a table with partitions - not possible
create table t1 (i1 integer, c integer, primary key(i1, c)) partition by hash(c) partitions 4;
insert into t1 values (2,3),(4,1),(6,1);

-- should fail
create table t2 (like t1);

-- should fail
drop table t2;
drop table t1;

-- create-like  a table with inheritance - not possible
create table t1 (i1 integer );

create table t2 (i2 integer );

alter table t2 add superclass t1;
alter table t2 add class attribute i3 integer,i4 integer inherit  i1 of t1;
-- should fail
create table t3 (like t2);

-- should fail
drop table t3;
drop table t2;
drop table t1;


-- create-like  a table with methods - not possible
create table t1 (i1 integer );

create table t2 (i2 integer );

alter table t2 add method m1;

-- should fail
create table t3 (like t2);

-- should fail
drop table t3;
drop table t2;
drop table t1;


-- create-like  a table with class attributes 
create table t2 (i2 integer );

alter table t2 add class attribute i3 integer;

insert into t2 values (1), (3);

create table t3 (like t2);

insert into t3 values (2), (4);
select * from t2 order by 1;
select * from t3 order by 1;

drop table t3;
drop table t2;


-- create-like  a table with unique constraints
create table t1 (i1 integer unique key, c integer );
insert into t1 values (2,3),(4,1),(6,1);

-- should fail
create table t2 (like t1);
insert into t2 values (2,3);
-- this should fail
insert into t2 values (2,1);
select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;


-- create-like  a table with foreign key constraints
create table t1 (i1 integer primary key);
create table t2 (i2 integer foreign key references t1(i1));

insert into t1 values (2),(4),(6);
insert into t2 values (2),(4),(6);
-- should fail
insert into t2 values (7);

-- should fail
create table t3 (like t2);
insert into t3 values (2),(4);
-- this should fail
insert into t2 values (9);
select * from t1 order by i1;
select * from t2 order by i2;
select * from t3 order by i2;

drop table t3;
drop table t2;
drop table t1;



-- create-like  a table with autoincrement
create table t1 (i1 integer auto_increment (0,2), c integer );
insert into t1(c) values (3),(1),(1);

-- should fail
create table t2 (like t1);

select * from t1 order by i1;
-- should fail
drop table t2;
drop table t1;








