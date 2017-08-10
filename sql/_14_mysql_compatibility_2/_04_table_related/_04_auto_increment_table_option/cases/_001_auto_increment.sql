-- test the AUTO_INCREMENT table option (MySQL compatibility)

-- ambiguities

create table t (i int) auto_increment = 23;

create table t (i int auto_increment, j int auto_increment) auto_increment = 23;

create table t (i int auto_increment(100, 2)) auto_increment = 3;

-- standard case
create table t (i int auto_increment primary key, j int) auto_increment = 10;

insert into t values (NULL, 1), (NULL, 2);
select * from t order by i;

-- new value lower than current: should NOT GENERATE AN ERRROR
alter table t auto_increment = 9;

-- works ok
insert into t values (NULL, 1009);

-- this will fail with a primary key unique violation error
insert into t values (NULL, 1010);

-- good case
alter table t auto_increment = 23;
insert into t values (NULL, 3), (NULL, 4);
select * from t order by i,j;

-- creating some gaps
delete from t where j > 2;
insert into t values (NULL, 5), (NULL, 6);
select * from t order by i,j;

drop table t;

-- ambiguities on alter
create table t (i int auto_increment, j int auto_increment);
create table u (i int, j string);

-- ambiguity: 2 columns, which one to choose?
alter table t auto_increment = 100;

-- ambig: no column to change
alter table u auto_increment = 10;


drop table t;
drop table u;

create table t (i int auto_increment, j int);

-- uninitialized serial
alter table t auto_increment = 10;
insert into t values (NULL, 1), (NULL, 2);
select * from t order by i,j;

-- should fail
alter table t drop column i, auto_increment = 23;
alter table t drop column i;

-- should work ok
alter table t add column i int auto_increment, auto_increment = 23;

-- duplicate alter
alter table t auto_increment = 100, auto_increment = 42;
insert into t (i,j) values (NULL, 10), (NULL, 11);
select * from t order by i,j;
drop table t;


-- rename table inbetween
create table t (i int);
alter table t add column ai int auto_increment, rename to u, auto_increment = 100;
insert into u values (23,null), (23,null);
select ai from u order by ai;
drop table u;

-- multiple options
create table t (i int auto_increment, j int) auto_increment = 23, reuse_oid;
commit;
select is_reuse_oid_class from db_class where class_name = 't';
drop table t;

create table t (i int auto_increment, j int) reuse_oid, auto_increment = 23;
commit;
select is_reuse_oid_class from db_class where class_name = 't';
drop table t;


-- should fail
create table t (i int auto_increment, j int) auto_increment = 23, reuse_oid, auto_increment = 42;



-- should complain about new value too big (i is int, so the serial has a max value
-- of about 2147000000).
create table t (i int auto_increment, j int);
alter table t auto_increment = 2148000000;
drop t;

-- here the max value should be big enough
create table t (i BIGINT auto_increment, j int);
alter table t auto_increment = 2148000000;
insert into t values (NULL, 1);
select * from t order by i;
drop t;

