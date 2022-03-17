--+ holdcas on;
-- test ALTER VIEW ... AS SELECT ...

create table t (i int, j int, k int, d double, n numeric, s varchar(100));

insert into t values (1,2,3,23e83, 1001,'vlad'), (10,20,30,1e2, 2002, 'tepes');


create view w as select * from t;

select * from w order by i asc;

-- change the view's query, deduce the column names and types
alter view w as select i,j,k from t;

select * from w order by i asc;

-- single column
alter view w as select d from t;
select * from w order by d asc;

-- create vclass hierarchy
create view father (i int);
create view son as subclass of father (j int);

-- should not allow vclasses to be altered with alter view as select
alter view father as select * from t;
alter view son as select * from t;

drop view father;
drop view son;

-- bad query: should fail
alter view w as select nonexistentfield from t;

-- bad union: should fail
alter view w as select i,j from t UNION select i from t;

-- the union should convert the int to double
alter view w as select i from t UNION select d from t;

-- see if this is the case
select * from w order by i asc;

-- create a view with no columns (CUBRID specific)
create view v;

-- allow the view to be altered
alter view v as select i, s from t;

select * from v order by i asc;

-- view defined as select from another view
alter view w as select s from v;

select * from w order by s asc;

drop view v;


-- view with multiple queries
create view v as select i from t, select j from t;

-- zap all the queries from v
alter view v as select d from t;

-- check that only the replacement query is present
select * from v order by d asc;

-- comma-separated selects in alter view definition not allowed
alter view w as select i from t,select j from t;


-- user permissions fun!
create user user1;
grant select on w to user1;

alter view w as select * from t;

call login('user1') on class db_user;

-- user1 should still have its rights to select from w
select * from dba.w order by i asc;

call login('dba') on class db_user;
drop user user1;


drop view v;
drop view w;


drop table t;
--+ holdcas off;
