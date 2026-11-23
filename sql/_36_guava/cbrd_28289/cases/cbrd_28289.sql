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
 *  The cases from Case 4 check defects of NUMERIC conversion fixed with this issue.
 *
 *  Coverage:
 *    Case 1:  rows kept by numeric(10,2) to numeric(12,2) give the same results as the twin
 *    Case 2:  rows kept by numeric(12,2) to numeric read as float NUMERIC, same as the twin
 *    Case 3:  UPDATE and DELETE of kept rows, then the same rows as the twin
 *    Case 4:  a constant folded to NUMERIC and assigned by UPDATE is converted to the column type, also on a cached plan
 *    Case 5:  a DOUBLE near 1e-252 converts to NUMERIC within the scale limit of 252
 *    Case 6:  INSERT SELECT of an integer into NUMERIC of a negative scale
 *    Case 7:  BIGINT to NUMERIC keeps the target precision and raises an overflow
 *    Case 8:  a DOUBLE zero converts to NUMERIC of a negative scale or of a scale above 40
 *    Case 9:  an index scan of NUMERIC of a negative scale compared with an integer returns the rows of a full scan
 *    Case 10: DESC and SHOW COLUMNS print the scale of NUMERIC, negative or not
 *    Case 11: ELT of NUMERIC whose scale is not below its precision, negative, and of a negative scale
 */

drop table if exists t_alt, t_alt_twin, t_flt, t_flt_twin, t_asg_num, t_asg_oth, t_tiny, t_neg, t_src, t_big, t_dbl, t_dbl_neg, t_negidx, t_desc;

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

evaluate 'Case 6: INSERT SELECT of an integer into NUMERIC of a negative scale';
create table t_neg (a numeric(1,-1));
create table t_src (i int, b bigint, s smallint);
insert into t_src values (10, 90, 0);
insert into t_neg select i from t_src;
insert into t_neg select b from t_src;
insert into t_neg select s from t_src;
select a from t_neg order by a;
-- the next INSERT fails on purpose: 100 needs 3 integer digits and numeric(1,-1) holds 2
insert into t_neg select i * 10 from t_src;
select count(*) from t_neg;

evaluate 'Case 7: BIGINT to NUMERIC keeps the target precision and raises an overflow';
create table t_big (b bigint);
insert into t_big values (10);
select cast(b as numeric(1,-1)), typeof(cast(b as numeric(1,-1))) from t_big;
select cast(b as numeric(2,0)), typeof(cast(b as numeric(2,0))) from t_big;
-- the next SELECT fails on purpose: 10 does not fit numeric(1,0), as for an INT
select cast(b as numeric(1,0)) from t_big;

evaluate 'Case 8: a DOUBLE zero converts to NUMERIC of a negative scale or of a scale above 40';
-- row 1 comes before the zero, so a zero that took the value of the row before it shows
create table t_dbl (id int, d double);
insert into t_dbl values (1, 1);
insert into t_dbl values (2, 0);
insert into t_dbl values (3, 100000);
select id, cast(d as numeric(30,-5)) from t_dbl order by id;
select id, cast(d as numeric(10,50)) from t_dbl where id = 2;
-- ROUND after the cast in the same SELECT
create table t_dbl_neg (v numeric(30,-5));
insert into t_dbl_neg values (0);
select cast(cast(v as double) as numeric(30,-5)), round(v, -2) from t_dbl_neg;

evaluate 'Case 9: an index scan of NUMERIC of a negative scale compared with an integer returns the rows of a full scan';
create table t_negidx (id int, v numeric(38,-10));
insert into t_negidx values (1, 0);
insert into t_negidx values (2, 10000000000);
insert into t_negidx values (3, 20000000000);
create index i_negidx_v on t_negidx (v);
-- each index scan is followed by the same query without the index
select id, v from t_negidx where v = 1 using index i_negidx_v order by id;
select id, v from t_negidx where v = 1 using index none order by id;
select id, v from t_negidx where v >= 1 using index i_negidx_v order by id;
select id, v from t_negidx where v >= 1 using index none order by id;
select id, v from t_negidx where v = 10000000000 using index i_negidx_v order by id;
select id, v from t_negidx where v = 10000000000 using index none order by id;

evaluate 'Case 10: DESC and SHOW COLUMNS print the scale of NUMERIC, negative or not';
create table t_desc (a numeric(5,-3), b numeric(38,-10), c numeric(3,10), d numeric(10,2), e numeric(10,0), f numeric);
desc t_desc;
show columns from t_desc;

evaluate 'Case 11: ELT of NUMERIC whose scale is not below its precision, negative, and of a negative scale';
select elt(1, cast(-0.125 as numeric(3,3)));
select elt(1, cast(-0.0000000125 as numeric(3,10)));
select elt(1, cast(0.125 as numeric(3,3)));
select elt(1, cast(-12.5 as numeric(3,1)));
select elt(1, cast(-12000 as numeric(2,-3)));
select elt(1, cast(-99000 as numeric(2,-3)));

drop table t_alt, t_alt_twin, t_flt, t_flt_twin, t_asg_num, t_asg_oth, t_tiny, t_neg, t_src, t_big, t_dbl, t_dbl_neg, t_negidx, t_desc;
