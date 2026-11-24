/**
 *  This test case verifies CBRD-28321: Fix NUMERIC defects in conversion, index key comparison, DESC and ELT
 *
 *  Each case is a defect of NUMERIC found while verifying CBRD-28289. Cases 1, 3, 4 and 5 come with a negative
 *  scale or a scale above 38, which CBRD-26006 brought in, and Cases 2 and 6 come with any scale.
 *
 *  Coverage:
 *    Case 1: INSERT SELECT of an integer into NUMERIC of a negative scale
 *    Case 2: BIGINT to NUMERIC keeps the target precision and raises an overflow
 *    Case 3: a DOUBLE zero converts to NUMERIC of a negative scale or of a scale above 40
 *    Case 4: an index scan of NUMERIC of a negative scale compared with an integer returns the rows of a full scan
 *    Case 5: DESC and SHOW COLUMNS print the scale of NUMERIC, negative or not
 *    Case 6: ELT of NUMERIC whose scale is not below its precision, negative, and of a negative scale
 */

drop table if exists t_neg, t_src, t_big, t_dbl, t_dbl_neg, t_negidx, t_desc;

evaluate 'Case 1: INSERT SELECT of an integer into NUMERIC of a negative scale';
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

evaluate 'Case 2: BIGINT to NUMERIC keeps the target precision and raises an overflow';
create table t_big (b bigint);
insert into t_big values (10);
select cast(b as numeric(1,-1)), typeof(cast(b as numeric(1,-1))) from t_big;
select cast(b as numeric(2,0)), typeof(cast(b as numeric(2,0))) from t_big;
-- the next SELECT fails on purpose: 10 does not fit numeric(1,0), as for an INT
select cast(b as numeric(1,0)) from t_big;

evaluate 'Case 3: a DOUBLE zero converts to NUMERIC of a negative scale or of a scale above 40';
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

evaluate 'Case 4: an index scan of NUMERIC of a negative scale compared with an integer returns the rows of a full scan';
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

evaluate 'Case 5: DESC and SHOW COLUMNS print the scale of NUMERIC, negative or not';
create table t_desc (a numeric(5,-3), b numeric(38,-10), c numeric(3,10), d numeric(10,2), e numeric(10,0), f numeric);
desc t_desc;
show columns from t_desc;

evaluate 'Case 6: ELT of NUMERIC whose scale is not below its precision, negative, and of a negative scale';
select elt(1, cast(-0.125 as numeric(3,3)));
select elt(1, cast(-0.0000000125 as numeric(3,10)));
select elt(1, cast(0.125 as numeric(3,3)));
select elt(1, cast(-12.5 as numeric(3,1)));
select elt(1, cast(-12000 as numeric(2,-3)));
select elt(1, cast(-99000 as numeric(2,-3)));

drop table t_neg, t_src, t_big, t_dbl, t_dbl_neg, t_negidx, t_desc;
