---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints  : UNIQUE KEY not maintained in new def
-- ordering : no order defined
-- name : same or different
-- type : same or different


--------------------- UNIQUE keys
------- type the same, UNIQUE not maintained in new def
-- UNIQUE should be KEPT
create table t1 (d1 double unique key);
insert into t1 values (1.112),(1.123);

-- should fail
insert into t1 values (1.112);

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change d1 d1 double;

-- should fail
insert into t1 values (1.112);
select * from t1 order by 1;
show columns in t1;

drop table t1;


------- type the same,  UNIQUE not maintained
--- unique on two columns + unique on one column attribute
-- UNIQUE one single column should be KEPT
create table t1 (i1 integer, d1 double unique key);
create unique index u_t1_i1_d1 on t1 (i1, d1);

insert into t1 values (6,1.112),(2,1.123);
-- should fail
insert into t1 values (3,1.112);

select * from t1 order by 1;
show columns in t1;

-- should be OK
alter table t1 change d1 d1 double;

-- should fail
insert into t1 values (3,1.112);

select * from t1 order by 1;
show columns in t1;

drop table t1;




------- type the same, loose UNIQUE
--- unique on two columns + unique on one column attribute
-- rename column
-- UNIQUE one single column should be KEPT
create table t1 (i1 integer, d1 double unique key);
create unique index u_t1_i1_d1 on t1 (i1, d1);

insert into t1 values (6,1.112),(2,1.123);
-- should fail
insert into t1 values (3,1.112);

select * from t1 order by 1;
show columns in t1;

-- should be OK
alter table t1 change d1 d_1 double;
-- should fail
insert into t1 values (3,1.112);

select * from t1 order by 1;
show columns in t1;

drop table t1;



