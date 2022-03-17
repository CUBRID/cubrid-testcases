-- field - 
create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, s3 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', '1234', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 'abcd', 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd','1234',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL,NULL);
select * from t1 order by s,b,d,s1,s2,i1;


--------------------------------------------------

select field('abcd',s2,'1234') from t1 order by s,b,d,s1,s2,i1;

select field('1234',s1,s2) from t1 order by s,b,d,s1,s2,i1;

select field(s1,s2,s3) from t1 order by s,b,d,s1,s2,i1;

-- should fail
select field(s1) from t1 order by s,b,d,s1,s2,i1;

select field('x',s1,s2) from t1 order by s,b,d,s1,s2,i1;

select field('x','1');

-- should fail
select field('x');

select field('x',NULL, NULL);

prepare st from 'select field(?,?,?)';
execute st using '1','2','1';


prepare st from 'select field(?,?,?)';
execute st using NULL,'2','1';

prepare st from 'select field(?,?,?)';
execute st using '1',NULL,'1';

-- should fail
select field(NULL);

select field('11','22','22','11');

drop prepare st;
drop table t1;
