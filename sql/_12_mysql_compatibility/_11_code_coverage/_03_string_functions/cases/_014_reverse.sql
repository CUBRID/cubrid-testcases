-- reverse 

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;


select reverse(s) from t1 order by s,b,d,s1,s2,i1;

select reverse(s2) from t1 order by s,b,d,s1,s2,i1;

select reverse(d) from t1 order by s,b,d,s1,s2,i1;

select reverse(b) from t1 order by s,b,d,s1,s2,i1;

select reverse(i1) from t1 order by s,b,d,s1,s2,i1;

select reverse(123);

select reverse('123');

select reverse(n'123');

select reverse(b'101101');

prepare st from 'select reverse(?)'
execute st using n'123';

prepare st from 'select reverse(?)'
execute st using '123';

select reverse(NULL);

drop table t1;


