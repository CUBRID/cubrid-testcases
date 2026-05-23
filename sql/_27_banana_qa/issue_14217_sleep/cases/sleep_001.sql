drop table if exists t1;

create table t1 (a float);
insert into t1 values(0.1),(0.2),(0.3);

select a, sleep(a) from t1 order by 1;
select sleep('abc');
select sleep(0.0);
select sleep(-0.2);
select sleep(NULL);

insert into t1 values(NULL);
select a, sleep(a) from t1 where a is null;

prepare s from 'select sleep(?)';
execute s using 0.1;
execute s using 'abc';
execute s using 0.0;
execute s using -0.2;
execute s using NULL;
deallocate prepare s;

drop table if exists t1; 


values(sleep(0));
values(sleep(-1));
values(sleep(a));
values(sleep(bacd));
values(sleep('bacd'));
values(sleep('efeffffffffffffffffffffffffffffff'));
values(sleep('\0'));
values(sleep("00\0"));
values(sleep(NULL));
values(sleep(select 1));
values(sleep(1/0));
/*
 * [Caution] Due to the db_sleep behavior change and NUMERIC range extension,
 * extremely large inputs can cause effectively infinite waits.
 *
 * Background:
 *   When db_sleep casts the input (double) to long (milliseconds),
 *   if an overflow occurs:
 *
 *   - Before:
 *       The value wrapped to a negative long, causing select() to return EINVAL,
 *       so db_sleep returned 1 immediately without sleeping.
 *
 *   - After:
 *       The overflow is detected and db_sleep sleeps for LONG_MAX milliseconds
 *       (on 64-bit Linux, 9,223,372,036,854,775,807 ms ≈ 292 million years,
 *        effectively resulting in an infinite wait).
 *
 * In addition, the NUMERIC range extension allows literals with precision
 * greater than 38 to reach db_sleep. The following huge inputs are therefore
 * commented out to prevent test execution from hanging.
 */
--values(sleep(111111111111111111111111111111111111111111111111111111111111111111111111111111));
values(sleep(0/1));
values(sleep(0x10));
values(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(sleep(0.1)+0.1)))+0.1))+0.1)))))))))))))))))))));

select(sleep(-1,2,3,4));
select(sleep(0));
select(sleep(-1));
select(sleep(a));
select(sleep(bacd));
select(sleep('bacd'));
select(sleep('efeffffffffffffffffffffffffffffff'));
select(sleep('\0'));

--bug
--select(sleep('0xfffffffffffffffffffffffffffffffffffffffffffffff'));

select(sleep("00\0"));
select(sleep(NULL));
select(sleep(select 1));
select(sleep(1/0));

--bug
--select(sleep(111111111111111111111111111111111111111111111111111111111111111111111111111111));

select(sleep(0/1));
select(sleep(0x10));
select(sleep(select round(1)));
select(sleep(0.00000000000000000000000000000000000000000000000001));
select(sleep(0.000000001));
select(sleep(0.01));

--bug
--select(sleep(1111111111111111111111111111111111));

select(sleep(cast(1-10 as double)));

--bug
--select(sleep(11111));
