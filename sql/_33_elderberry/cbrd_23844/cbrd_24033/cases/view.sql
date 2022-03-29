/* create view - check if the identifier name includes a dot(.). */

create user u1;
call login ('u1') on class db_user;
create table u1.t1 (c1 int, c2 varchar, c3 datetime);
create view u1.v1 as select c1, c2, c3 from t1;

create view u1.v1.v1 as select c1, c2, c3 from t1;
create view [v2.v2] as select c1, c2, c3 from t1;
create view "v3.v3" as select c1, c2, c3 from t1;
create view `v4.v4` as select c1, c2, c3 from t1;

call login ('u1') on class db_user;
drop view v1;
drop table t1;
call login ('dba') on class db_user;
drop user u1;
