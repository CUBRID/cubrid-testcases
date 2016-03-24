drop table if exists t1;

CREATE TABLE t1 (a int , b int );
insert into t1 values (1,1);

do @a := (select a from t1);

drop table if exists t1;
