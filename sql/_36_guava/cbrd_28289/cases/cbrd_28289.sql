/**
 *  This test case verifies CBRD-28289: Carry the digits of a fixed NUMERIC in its header as a float one does,
 *  so that ALTER widening a fixed NUMERIC column rewrites no row
 *
 *  A fixed NUMERIC now keeps the digits of its value in its header. ALTER from a fixed NUMERIC to a float one, and
 *  ALTER to a larger precision with the same scale, change only the schema, and the rows inserted before the ALTER
 *  stay as they were and are read in the current column type. Before the change both ALTERs rewrote every row.
 *  Each altered table has a twin created with the final column type and the same rows, and the two must print the
 *  same. ALTER of NUMERIC to NUMERIC with a scale change or a smaller precision is checked by the TCs of
 *  _22_type_numeric, and the indexes of an altered column by a later issue, so neither is repeated here.
 *  Case 4 and Case 5 check defects of NUMERIC conversion fixed with this issue.
 *
 *  Coverage:
 *    Case 1: rows kept by numeric(10,2) to numeric(12,2) give the same results as the twin
 *    Case 2: rows kept by numeric(12,2) to numeric read as float NUMERIC, same as the twin
 *    Case 3: UPDATE and DELETE of kept rows, then the same rows as the twin
 *    Case 4: a constant folded to NUMERIC and assigned by UPDATE is converted to the column type, also on a cached plan
 *    Case 5: a DOUBLE near 1e-252 converts to NUMERIC within the scale limit of 252
 */

drop table if exists t_alt, t_alt_twin, t_flt, t_flt_twin, t_asg_num, t_asg_oth, t_tiny;

evaluate 'Case 1: rows kept by numeric(10,2) to numeric(12,2) give the same results as the twin';
create table t_alt (id int primary key, a numeric(10,2), b numeric(10,2));
insert into t_alt values (1, 0, null);
insert into t_alt values (2, 1.25, 1.25);
insert into t_alt values (3, -99999999.99, 99999999.99);
insert into t_alt values (4, 2.55, -2.56);
insert into t_alt values (5, null, 0.01);
alter table t_alt modify a numeric(12,2);
alter table t_alt modify b numeric(12,2);
-- rows 6 and 7 are inserted after the ALTERs, row 6 with more digits than numeric(10,2) holds
insert into t_alt values (6, 9999999999.99, -1234567890.12);
insert into t_alt values (7, 1.25, 100);
create table t_alt_twin (id int primary key, a numeric(12,2), b numeric(12,2));
insert into t_alt_twin select id, a, b from t_alt;
select id, a, b, typeof(a), typeof(b) from t_alt order by id;
select id, a, b, typeof(a), typeof(b) from t_alt_twin order by id;
select id, a + b, a * 2, b / 4, -a, abs(b), round(a, 1), cast(a as numeric), cast(b as varchar) from t_alt order by id;
select id, a + b, a * 2, b / 4, -a, abs(b), round(a, 1), cast(a as numeric), cast(b as varchar) from t_alt_twin order by id;
select a, count(*), sum(b) from t_alt group by a order by a;
select a, count(*), sum(b) from t_alt_twin group by a order by a;
select x.id, y.id from t_alt x, t_alt_twin y where x.a = y.a and x.b = y.b order by x.id, y.id;

evaluate 'Case 2: rows kept by numeric(12,2) to numeric read as float NUMERIC, same as the twin';
create table t_flt (id int primary key, a numeric(12,2));
insert into t_flt values (1, 0);
insert into t_flt values (2, 1.50);
insert into t_flt values (3, -9999999999.99);
insert into t_flt values (4, null);
insert into t_flt values (5, 0.01);
alter table t_flt modify a numeric;
-- rows 6 to 8 are inserted after the ALTER, as float NUMERIC values
insert into t_flt values (6, 1.5);
insert into t_flt values (7, 1234567890123456789012345678901234567890);
insert into t_flt values (8, 1e-100);
create table t_flt_twin (id int primary key, a numeric);
insert into t_flt_twin select id, a from t_flt;
select id, a, typeof(a) from t_flt order by id;
select id, a, typeof(a) from t_flt_twin order by id;
select id, a + 1, a * a, cast(a as numeric(38,2)), cast(a as double) from t_flt where id < 7 order by id;
select id, a + 1, a * a, cast(a as numeric(38,2)), cast(a as double) from t_flt_twin where id < 7 order by id;
select a, count(*) from t_flt group by a order by a;
select a, count(*) from t_flt_twin group by a order by a;

evaluate 'Case 3: UPDATE and DELETE of kept rows, then the same rows as the twin';
update t_alt set a = a + 1 where id in (2, 3);
update t_alt_twin set a = a + 1 where id in (2, 3);
delete from t_alt where id = 4;
delete from t_alt_twin where id = 4;
update t_flt set a = a * 10 where id = 2;
update t_flt_twin set a = a * 10 where id = 2;
select id, a, b from t_alt order by id;
select id, a, b from t_alt_twin order by id;
select id, a from t_flt order by id;
select id, a from t_flt_twin order by id;

evaluate 'Case 4: a constant folded to NUMERIC and assigned by UPDATE is converted to the column type, also on a cached plan';
-- 1.2 + 0 is folded to a float NUMERIC constant and becomes an auto parameter of the column type.
-- An UPDATE that differs only in its constants reuses the cached plan of the one before it.
create table t_asg_num (id int, b numeric(10,2));
insert into t_asg_num values (1, 0);
update t_asg_num set b = 1.2 + 0 where id = 1;
select id, b, typeof(b) from t_asg_num;
update t_asg_num set b = 3.456 + 0 where id = 1;
select id, b, typeof(b) from t_asg_num;
create table t_asg_oth (id int, i int, d double, v varchar(20));
insert into t_asg_oth values (1, 0, 0, '');
update t_asg_oth set i = 1.5 + 0, d = 1.2 + 0, v = 0.5 + 0 where id = 1;
select id, i, d, v from t_asg_oth;
update t_asg_oth set i = 2.5 + 0, d = 7.25 + 0, v = 12.75 + 0 where id = 1;
select id, i, d, v from t_asg_oth;
update t_asg_oth set i = -3.5 + 0, d = -0.125 + 0, v = -1.5 + 0 where id = 1;
select id, i, d, v from t_asg_oth;

evaluate 'Case 5: a DOUBLE near 1e-252 converts to NUMERIC within the scale limit of 252';
create table t_tiny (id int, d double);
insert into t_tiny values (1, 1.2345678901234567e-252);
insert into t_tiny values (2, 1.2345678901234567e-240);
insert into t_tiny values (3, -1.2345678901234567e-240);
select id, cast(d as numeric(10,2)) from t_tiny order by id;
select id, cast(d as numeric) from t_tiny order by id;

drop table t_alt, t_alt_twin, t_flt, t_flt_twin, t_asg_num, t_asg_oth, t_tiny;
