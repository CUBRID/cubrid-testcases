-- mid 

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

SELECT MID(s, i1,2) from t1 order by s,b,d,s1,s2,i1;

SELECT MID(b, i1,2) from t1 order by s,b,d,s1,s2,i1;

SELECT MID(s1, i1,2) from t1 order by s,b,d,s1,s2,i1;

SELECT MID(s1, 2, i1) from t1 order by s,b,d,s1,s2,i1;


select mid(s2,-1,-1) from t1 order by s,b,d,s1,s2,i1;

select mid('1223',-1,-1);

select mid('1223',-1,1);

select mid('1223',-21,1);

select mid(b'1010',1,1);

select mid(b'1010',-1,1);

select mid('1',2,NULL);


drop table t1;


