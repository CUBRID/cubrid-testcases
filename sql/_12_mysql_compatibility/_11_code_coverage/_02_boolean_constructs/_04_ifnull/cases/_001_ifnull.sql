create table t1(i1 integer, b bigint, sh short, f float, d double,d1 date,n numeric(10,2));

insert into t1 values (1, 1230, 1, 1.2, 1.3,date'2010-10-10',2);

-- should fail
select ifnull(i1,b) from t1;

select ifnull(d1,b) from t1;

select ifnull(b,d1) from t1;

select ifnull(NULL,NULL) from t1;

select ifnull(i1,NULL) from t1;

select ifnull(d,d) from t1;

select ifnull(f,f) from t1;

select ifnull(n,n) from t1;

select ifnull(b,b) from t1;

select ifnull(sh,sh) from t1;

select ifnull(i1,i1) from t1;


select ifnull(i1,sh) from t1;

select ifnull(n,sh) from t1;

select ifnull(b,i1) from t1;

select ifnull(b,n) from t1;

drop table t1;


create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,d,s1,s2,5,6;

SELECT IFNULL(i1,s1) from t1 order by i1;

drop table t1;
