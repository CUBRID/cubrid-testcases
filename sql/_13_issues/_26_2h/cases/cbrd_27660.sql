/**
 *  CBRD-27660: a DOUBLE, MONETARY or string value that rounds out of the INTEGER range must raise an overflow
 *  error when it is cast or assigned to INTEGER, and so must a NaN cast to SMALLINT.
 *
 *  The conversion rounds half away from zero and then narrows, so a value in [2147483647.5, 2147483648) rounds
 *  to 2147483648, one past the INTEGER range: it was returned and stored as -2147483648 with no error. A value
 *  that rounds into the range and the exact limits still convert, as before.
 */

drop table if exists t_src, t_int;

create table t_src (id int, d double, m monetary, s varchar(32));
create table t_int (id int, a int);

insert into t_src values (1, 2147483647.4e0, 2147483647.4, '2147483647.4');
insert into t_src values (2, 2147483647.5e0, 2147483647.5, '2147483647.5');
insert into t_src values (3, 2147483647.999e0, 2147483647.999, '2147483647.999');


evaluate 'Case 1: a constant in [2147483647.5, 2147483648) cast to INT overflows';
select cast(2147483647.5e0 as int);
select cast('2147483647.5' as int);
select cast(cast(2147483647.5 as monetary) as int);
select cast(2147483647.999e0 as int);
select cast(' 2.1474836475e9 ' as int);
select cast(-2147483648.5e0 as int);


evaluate 'Case 2: a value that rounds into the range converts, and so do the limits';
select cast(2147483647.4e0 as int), cast('2147483647.4' as int), cast(cast(2147483647.4 as monetary) as int);
select cast('2147483647' as int), cast('-2147483648' as int), cast(-2147483648e0 as int), cast(-2147483647.5e0 as int);
select cast('32767' as smallint), cast('-32768' as smallint), cast(32767e0 as smallint), cast(-32767.5e0 as smallint);
select cast(32767.5e0 as smallint);
select cast(2147483647.5e0 as bigint), cast(cast(2147483647.5 as monetary) as bigint);


evaluate 'Case 3: column values cast on the server';
select id, cast(d as int) from t_src where id = 1;
select id, cast(m as int) from t_src where id = 1;
select id, cast(s as int) from t_src where id = 1;
select id, cast(d as int) from t_src where id = 2;
select id, cast(m as int) from t_src where id = 2;
select id, cast(s as int) from t_src where id = 2;
select id, cast(d as int) from t_src where id = 3;


evaluate 'Case 4: an assignment to an INT column overflows and stores nothing';
insert into t_int values (1, 1);
insert into t_int values (2, 2147483647.5e0);
insert into t_int select id, d from t_src where id >= 1 order by id;
insert into t_int select id, m from t_src where id = 2;
insert into t_int select id, s from t_src where id = 2;
update t_int set a = (select d from t_src where id = 2) where id = 1;
insert into t_int select id + 10, d from t_src where id = 1;
select id, a from t_int order by id;


evaluate 'Case 5: a NaN cast to SMALLINT overflows, as it does for INT';
select cast('nan' as smallint);
select cast(cast('nan' as double) as smallint);
select cast('nan' as int);


drop table t_src, t_int;
