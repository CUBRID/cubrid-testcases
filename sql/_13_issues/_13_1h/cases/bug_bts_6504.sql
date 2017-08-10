drop table if exists t1;
CREATE TABLE t1 (a int , b int );
insert into t1 values (1,1);
--below will throw "ERROR: System error (generate var) in ../../src/parser/xasl_generation.c (line: 8850)"
do @a := (select a from t1);
select @a;
do @b := (select (a*b)/(a*b) from t1);
select @b;
drop table t1;


CREATE TABLE t1 (a char(10) , b char(1) );
insert into t1 values ('1','1');
insert into t1 values ('2','2');
do @a := (select max(a) from t1);
select @a;

delete from t1;
do @b := (select a+b from t1 );
select @b;
drop variable @a,@b;
drop table t1;
