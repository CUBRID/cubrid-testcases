--+ holdcas on;
-- substring 

create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

set system parameters 'compat_mode=cubrid';
select substring(s,2,1) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,2,1) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,2) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(d,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(b,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(b,i1,2) from t1 order by s,b,d,s1,s2,i1;

select substring(b,2,i1) from t1 order by s,b,d,s1,s2,i1;



set system parameters 'compat_mode=mysql';
select substring(s,2,1) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,2,1) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,2) from t1 order by s,b,d,s1,s2,i1;

select substring(s1,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(d,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(b,i1) from t1 order by s,b,d,s1,s2,i1;

select substring(b,i1,2) from t1 order by s,b,d,s1,s2,i1;

select substring(b,2,i1) from t1 order by s,b,d,s1,s2,i1;
set system parameters 'compat_mode=cubrid';



select substring(s2,2) from t1 order by s,b,d,s1,s2,i1;

set system parameters 'compat_mode=mysql';

select substring(s2,2) from t1 order by s,b,d,s1,s2,i1;

select substring('1223',2);

select substring('1223',-12);

select substring(b'10101',-2);

select substring('1',NULL);

select substring('1223',2,1);

select substring('1223',2,-1);

set system parameters 'compat_mode=cubrid';


drop table t1;


commit;
--+ holdcas off;
