-- concat , concat_ws - 
create table t1 (s nchar varying,b bit varying,d date, s1 char varying,s2 char varying, i1 integer);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234', 'abcd', 1);
insert into t1 values (NULL,b'1010101',date'2000-10-10','1234', 'abcd', -2);
insert into t1 values (n'1234',NULL,date'2000-10-10','1234', NULL, 0);
insert into t1 values (n'1234',b'1010101',NULL,NULL, 'abcd',-21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10',NULL,NULL,21);
insert into t1 values (n'1234',b'1010101',date'2000-10-10','1234','abcd',NULL);
select * from t1 order by s,b,d,s1,s2,i1;

select concat(s2,'1') from t1  order by s,s2;

select concat(s2) from t1 order by s,s2;

select concat(s2,s2) from t1 order by s,s2;

select concat(s2,s2,s2) from t1 order by s,s2;

select concat('x',s2,'1') from t1 order by s,s2;

select concat('1','2','1');

select concat('1','1');

select concat('1');

--------------------------------------------------

select concat_ws('x',s2,'1') from t1 order by s,s1,s2;

select concat_ws('x',s2) from t1 order by s,s1,s2;

-- should fail
select concat_ws(s2) from t1 order by s,s1,s2;

select concat_ws('x',s1,s2) from t1 order by s,s1,s2;

select concat_ws('x','1');

-- should fail
select concat_ws('x');

select concat_ws('x','2','1');


prepare st from 'select concat(?,?,?)';
execute st using '1','2','1';

prepare st from 'select concat_ws(?,?,?)';
execute st using 'x','2','1';

select concat(NULL);

select concat_ws(NULL);

drop table t1;

--add new test case for issue 6524 
create table t1(a int,b char(20));

insert into t1 values(-1,'');

insert into t1 values(-2,'a');

insert into t1 values(-3,' ');

insert into t1 values(-4,'b');

select concat(b) from t1;

select concat(b) from t1 group by a;

drop prepare st;
drop table t1;
