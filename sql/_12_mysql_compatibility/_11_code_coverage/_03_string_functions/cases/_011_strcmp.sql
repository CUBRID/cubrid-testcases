-- strcmp 

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

select strcmp(s,'123') from t1 order by s,b,d,s1,s2,i1;

select strcmp(s,n'1234') from t1 order by s,b,d,s1,s2,i1;

select strcmp(s2,'1234') from t1 order by s,b,d,s1,s2,i1;

select strcmp('1234',s2) from t1 order by s,b,d,s1,s2,i1;

select strcmp(s2,s1) from t1 order by s,b,d,s1,s2,i1;

select strcmp(b,b'1010101') from t1 order by s,b,d,s1,s2,i1;

select strcmp(d,'2000-10-10') from t1 order by s,b,d,s1,s2,i1;

select strcmp(i1,21) from t1 order by s,b,d,s1,s2,i1;



select strcmp(n'1223','0123');

select strcmp('1223','0123');

select strcmp(b'10101',b'1101');


select strcmp(s2,'0123') from t1 order by s,b,d,s1,s2,i1;

prepare st from 'select strcmp(?,?)'
execute st using n'1',n'3';

prepare st from 'select strcmp(?,?)'
execute st using '123','43';
drop prepare st;

drop table t1;


