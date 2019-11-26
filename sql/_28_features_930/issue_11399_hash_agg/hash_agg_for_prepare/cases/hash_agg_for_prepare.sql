--+ holdcas on;
drop table if exists t1;
create table t1(a int, b double, c char(10));
insert into t1 values(1,777,'cc');

insert into t1 values(2,3377,'cd');
insert into t1 values(3,3397,'cad'); 
insert into t1 values(3,3397,'cad');
insert into t1 values(5,37,'cd');


prepare s from 'select sum(?) from t1 group by c';
execute s using 'b';

set @v1='c';
execute s using @v1;
execute s using 1299.2
deallocate prepare s;


prepare s1 from 'select ?,sum(b) from t1 group by b';
execute s1 using 1;
execute s1 using '1';
execute s1 using 'a';
deallocate prepare s1;


prepare s2 from 'select ?+?,sum(b) from t1 group by b';
execute s2 using 1,2;
execute s2 using 1,'a';
execute s2 using 'a','b';
execute s2 using 'a','c';
deallocate prepare s2;

prepare s3 from 'select a,sum(b) from t1 group by ?';
execute s3 using 1;
execute s3 using 'b';
execute s3 using 3;
deallocate prepare s3;

prepare s4 from 'select a,sum(b) from (select a, b, ? from t1 where a>3 order by a DESC ) group by ?';
execute s4 using 'c',1;
execute s4 using 3, 2;
deallocate prepare s4;

prepare s5 from 'select min(a),sum(?+?) from t1 group by c';
execute s5 using 1,4;
execute s5 using 'b','c';
deallocate prepare s5;

prepare s6 from 'select a,sum(b) from (select a, b, ? from t1 where a>3 order by a DESC ) group by a>?';
execute s6 using 3, 1;
execute s6 using 4, 2;
execute s6 using 4, 'b';
deallocate prepare s6
drop variable @v1;
drop table t1;


--+ holdcas off;
