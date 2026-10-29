/**
 *  CBRD-27660: a DOUBLE, MONETARY, string or JSON value above 2147483647 must raise an overflow error when it is cast
 *  or assigned to INTEGER, as a NUMERIC value does and as the other integer limits do. A NaN must raise an overflow
 *  when it is cast or assigned to SMALLINT or cast to TIME, as it does for INTEGER.
 *
 *  Before the fix a value in [2147483647.5, 2147483648) rounded to 2147483648, one past the INTEGER range, and was
 *  returned and stored as -2147483648 with no error, a value in (2147483647, 2147483647.5) gave 2147483647, and a NaN
 *  gave 0 as SMALLINT and an invalid TIME. The limits and the values inside the range still convert, rounding half
 *  away from zero.
 */

drop table if exists t_src, t_int, t_short;

create table t_src (id int, d double, m monetary, s varchar(32));
create table t_int (id int, a int);
create table t_short (id int, a smallint, d double, v varchar(8));

insert into t_src values (1, 2147483647e0, 2147483647, '2147483647');
insert into t_src values (2, 2147483647.4e0, 2147483647.4, '2147483647.4');
insert into t_src values (3, 2147483647.5e0, 2147483647.5, '2147483647.5');


evaluate 'Case 1: a constant above 2147483647 cast to INT overflows, whether or not it rounds into the range';
select cast(2147483647.4e0 as int);
select cast('2147483647.4' as int);
select cast(cast(2147483647.4 as monetary) as int);
select cast(2147483647.5e0 as int);
select cast('2147483647.5' as int);
select cast(cast(2147483647.5 as monetary) as int);
select cast(2147483647.999e0 as int);
select cast(' 2.1474836475e9 ' as int);
select cast(cast('2147483647.5' as json) as int);
select cast(cast('2147483647.4' as json) as int);


evaluate 'Case 2: the same rule at the other limits and for NUMERIC';
select cast(2147483647.4 as int);
select cast(-2147483648.4e0 as int);
select cast(-2147483648.5e0 as int);
select cast(32767.4e0 as smallint);
select cast(-32768.4e0 as smallint);


evaluate 'Case 3: the limits and the values inside the range convert, rounding half away from zero';
select cast('2147483647' as int), cast(2147483647e0 as int), cast(cast(2147483647 as monetary) as int);
select cast(2147483646.5e0 as int), cast('2147483646.5' as int), cast(-2147483647.5e0 as int);
select cast('-2147483648' as int), cast(-2147483648e0 as int);
select cast('32767' as smallint), cast('-32768' as smallint), cast(32766.5e0 as smallint), cast(-32767.5e0 as smallint);
select cast(2147483647.5e0 as bigint), cast(cast(2147483647.5 as monetary) as bigint);


evaluate 'Case 4: column values cast on the server';
select id, cast(d as int), cast(m as int), cast(s as int) from t_src where id = 1;
select id, cast(d as int) from t_src where id = 2;
select id, cast(m as int) from t_src where id = 2;
select id, cast(s as int) from t_src where id = 2;
select id, cast(d as int) from t_src where id = 3;
select id, cast(m as int) from t_src where id = 3;
select id, cast(s as int) from t_src where id = 3;


evaluate 'Case 5: an assignment to an INT column overflows and stores nothing';
insert into t_int values (1, 1);
insert into t_int values (2, 2147483647.4e0);
insert into t_int values (3, 2147483647.5e0);
insert into t_int select id, d from t_src order by id;
insert into t_int select id, m from t_src where id = 2;
insert into t_int select id, s from t_src where id = 3;
update t_int set a = (select d from t_src where id = 3) where id = 1;
insert into t_int select id + 10, d from t_src where id = 1;
select id, a from t_int order by id;


evaluate 'Case 6: a NaN cast or assigned to SMALLINT overflows, as it does for INT';
select cast('nan' as smallint);
select cast(cast('nan' as double) as smallint);
select cast('nan' as int);
insert into t_short values (1, 1, cast('nan' as double), 'nan');
update t_short set a = d where id = 1;
update t_short set a = v where id = 1;
insert into t_short (id, a) select 2, d from t_short where id = 1;
select id, a from t_short order by id;


evaluate 'Case 7: a NaN cast to TIME overflows, and TIMESTAMP takes the INTEGER rule';
select cast(cast('nan' as double) as time);
select cast(cast(cast('nan' as double) as monetary) as time);
select cast(3661.4e0 as time), cast(cast(3661.5 as monetary) as time);
select cast(2147483647.5e0 as timestamp);
select cast(2147483647.4e0 as timestamp);


drop table t_src, t_int, t_short;
