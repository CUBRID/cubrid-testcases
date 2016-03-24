-- right

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

SELECT RIGHT(s, i1) from t1 order by s,b,d,s1,s2,i1;

SELECT RIGHT(b, i1) from t1 order by s,b,d,s1,s2,i1;

SELECT RIGHT(s1, i1) from t1 order by s,b,d,s1,s2,i1;


select right(s,2) from t1 order by s,b,d,s1,s2,i1;

select right('1231',2);

select right(n'1231',2);

select right(b'101101',2);

prepare st from 'select right(?,?)'
execute st using n'1',2;

prepare st from 'select right(?,?)'
execute st using '12311',date'2000-10-10';

select right(NULL);

drop table t1;


