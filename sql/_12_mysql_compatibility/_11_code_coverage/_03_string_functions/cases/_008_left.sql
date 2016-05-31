-- left 

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

SELECT LEFT(s, i1) from t1 order by LEFT(s, i1) asc;

SELECT LEFT(b, i1) from t1 order by LEFT(b, i1) asc;

SELECT LEFT(s1, i1) from t1 order by LEFT(s1, i1) asc ;

select left(s,2) from t1 order by left(s,2) asc;

select left('1231',2);

select left(n'1231',2);

select left(b'101101',2);

prepare st from 'select left(?,?)'
execute st using n'1',2;

prepare st from 'select left(?,?)'
execute st using '12311',date'2000-10-10';

-- should fail
select left(NULL);

drop prepare st;
drop table t1;


