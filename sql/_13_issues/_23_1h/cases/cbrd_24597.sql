/* Description
The CBRD-24597 is 'Coercing error for numeric type when using prepare-execute'
When using the numeric type & prepare-execute then sometimes the CUBRID has returned the incorrect result.
It could reproduce if set a scale value at over 1 in a numeric type column.
*/

drop if exists t1, t2, t3, t4, t5;

-- issue's scenario
create table t1(a numeric(10,1), b int);
insert into t1 values(1,1);
prepare s from 'select * from t1 where a <= ?';

create index idx on t1 (a);

drop index idx on t1;

create index idx on t1 (a, b);
select * from t1 where a <= '1';
execute s using '1';
execute s using 1;
deallocate prepare s;

-- alter table modify column numeric(10,1) -> numeric(10,3)
create table t2(a numeric(10,1), b int);
insert into t2 values(1,2);
prepare s from 'select * from t2 where a <= ?';

create index idx on t2 (a);

drop index idx on t2;

alter table t2 modify column a numeric(10,3);

create index idx on t2 (a, b);
select * from t2 where a <= '1';
execute s using '1';
execute s using 1;
deallocate prepare s;

-- alter table modify column numeric(10,0) -> numeric(10,3)
create table t3(a numeric(10,0), b int);
insert into t3 values(1,3);
prepare s from 'select * from t3 where a <= ?';

create index idx on t3 (a);

drop index idx on t3;

alter table t3 modify column a numeric(10,3);

create index idx on t3 (a, b);
select * from t3 where a <= '1';
execute s using '1';
execute s using 1;
deallocate prepare s;

-- alter table modify column numeric(10,3) -> numeric(10,1)
create table t4(a numeric(10,3), b int);
insert into t4 values(1,4);
prepare s from 'select * from t4 where a <= ?';

create index idx on t4 (a);

drop index idx on t4;

alter table t4 modify column a numeric(10,1);

create index idx on t4 (a, b);
select * from t4 where a <= '1';
execute s using '1';
execute s using 1;
deallocate prepare s;

-- alter table modify column numeric(10,3) -> numeric(10,0)
create table t5(a numeric(10,3), b int);
insert into t5 values(1,5);
prepare s from 'select * from t5 where a <= ?';

create index idx on t5 (a);

drop index idx on t5;

alter table t5 modify column a numeric(10,0);

create index idx on t5 (a, b);
select * from t5 where a <= '1';
execute s using '1';
execute s using 1;
deallocate prepare s;

drop t1, t2, t3, t4, t5;
