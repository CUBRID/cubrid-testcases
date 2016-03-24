--TEST: LPAD doesn't work in function index.

set names iso88591;
drop table if exists t1;

create table t1(a int);
insert into t1 values (-100);
insert into t1 values (10);

select (LPAD('CUBRID', a, 'X')) from t1 order by 1;
select (LPAD(a, 10, 'X')) from t1 order by 1; 
select (LPAD('CUBRID', 20, a)) from t1 order by 1; 

--test: will fail and throw "No error message available.". 
CREATE INDEX i1 on t1 (LPAD ('CUBRID', a, 'X'));
CREATE INDEX i2 on t1 (LPAD (a, 10, 'X'));
CREATE INDEX i3 on t1 (LPAD ('CUBRID', 20, a));


show index in t1;


drop table t1;


