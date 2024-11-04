create table t1(i1 integer, sh short, b bigint, d double, n numeric(10,2), s char varying);
insert into t1 values (1,2,3,4,5,'1234');
insert into t1 values (NULL,2,3,4,5,'1234');
insert into t1 values (1,NULL,3,4,5,'1234');
insert into t1 values (1,2,NULL,4,5,'1234');
insert into t1 values (1,2,3,NULL,5,'1234');
insert into t1 values (1,2,3,4,NULL,'1234');
insert into t1 values (1,2,3,4,5,NULL);


select bit_count(i1) from t1 order by 1;
select bit_count(sh) from t1 order by 1;
select bit_count(b) from t1 order by 1;

select bit_count(d) from t1 order by 1;

select bit_count(n) from t1 order by 1;
-- should fail
select bit_count(s) from t1 order by 1;

select bit_count(2);

prepare st from 'bit_count(?)'
execute st using 4;

deallocate prepare st;

drop table t1;
