--+ holdcas on;
drop table if exists t1;
create table t1(a int, b double, c char(10));

insert into t1 values(1,777,'cc');

insert into t1 values(2,3377,'cd');
insert into t1 values(3,3397,'cad'); 
insert into t1 values(3,3397,'cad');
insert into t1 values(5,37,'cd');

prepare s from 'select sum(?) from t1 group by c asc';
execute s using '1';
execute s using 'z';
deallocate prepare s;

prepare s1 from 'select count(?) from t1 group by c asc';
execute s1 using '1';
execute s1 using 'b';
deallocate prepare s1;

prepare s2 from 'select count(a)/sum(?) from t1 group by c asc';
execute s2 using '1';
execute s2 using 'b';
execute s2 using NULL;
execute s2 using '0';
execute s2 using 0;
deallocate prepare s2;

drop table t1;
--+ holdcas off;

