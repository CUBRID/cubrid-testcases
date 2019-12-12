create table t;
create table s (a int);
create table u (b int);
create table x (b int);

-- should throw an error
create view v as select * from t;
create view v as select * from (s,u);
create view v as select b from t;
create view v as select * from u,x;

drop s;
drop u;
drop t;
drop x;