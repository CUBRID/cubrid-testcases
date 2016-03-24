-- locate - 
create table t1 (s nchar varying,b bit varying,d date,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234',1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234',-2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234',0);
insert into t1 values (n'1234',b'1010101',NULL,'1234',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234',NULL);


select locate(s2,s) from t1 order by s,s2;

select locate(s,s2) from t1 order by s,s2;

select locate(s,s2,i1) from t1 order by s,s2;

select locate(s2,'2') from t1 order by s,s2;

select locate(s2,'xx1234xx') from t1 order by s,s2;

select locate(s2,'xx1234xx',1) from t1 order by s,s2;

select locate(s2,'xx1234xx',i1) from t1 order by s,s2,i1;

select locate(s2,'2',i1) from t1 order by s,s2,i1;

select locate('123456',s2,i1) from t1 order by s,s2,i1;

select locate(s,n'2',1) from t1 order by s,s2,i1;

-- should fail
select locate(b,b'1',1) from t1 order by s,s2;

-- should fail
select locate(d,'1',1) from t1 order by s,s2;

select locate(s2,'2',1) from t1 order by s,s2;

select locate('1','2',-1) order by s,s2;

-- should fail
select locate(n'1','2');

select locate('1','2',1);

select locate('1','2');

select locate(NULL,'2');

select locate('1',NULL);

select locate(NULL,NULL);

select locate(NULL,NULL,NULL);

-- should fail
select locate('1','2','1');

-- should fail
prepare st from 'select locate(?,?,?)'
execute st using '1','2','1';

prepare st from 'select locate(?,?,?)'
execute st using '1','2',1;

drop table t1;
