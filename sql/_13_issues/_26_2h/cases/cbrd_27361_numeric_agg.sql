/**
 *  This test case verifies CBRD-27361: an aggregate over one heap scan takes its rows a page at a time (the
 *  page batch), and its NUMERIC kernels must give the row path's answers: SUM, AVG, COUNT, MIN and MAX of
 *  coefficients of 1..8 and 9..16 bytes, negatives, NULLs, mixed scales, a sum beyond int64 below
 *  NUMERIC(38), NUMERIC constants of 1..15 digits at, below and beyond the column's scale and width, and a
 *  CHAR(300) column whose records the batch cannot read in place (every page goes to the row path).
 *  AVG is a DOUBLE and is printed through a NUMERIC cast so that the answer is exact.
 *
 *  Coverage:
 *    Case 1: SUM, AVG, COUNT, MIN, MAX of NUMERIC(5,2), (18,3), (20,4), (38,6), (10,0), with filters
 *    Case 2: NUMERIC constants of 1..15 digits and beyond the column's width
 *    Case 3: a CHAR(300) column: "=", LIKE, and a filter mixing it with a VARCHAR
 */


evaluate 'Case 1: NUMERIC: coefficients of 1..8 and 9..16 bytes, negatives, NULLs, mixed scales, an int64 overflow below NUMERIC(38)';
drop table if exists t_num;
create table t_num (id int, n1 numeric(5,2), n8 numeric(18,3), n9 numeric(20,4), n16 numeric(38,6), n0 numeric(10,0));
insert into t_num
  select n,
    case mod(n, 5) when 0 then null when 1 then -1.25 when 2 then 999.99 when 3 then 0.01 else mod(n, 100) * 1.5 end,
    case mod(n, 6) when 0 then null when 1 then -123456789012.345 when 2 then 999999999999999.999 when 3 then 0.001 when 4 then -0.5 else n * 24.0 end,
    case mod(n, 4) when 0 then null when 1 then -9999999999999999.9999 when 2 then 1234567890123456.7891 else n / 3.0 end,
    case mod(n, 3) when 0 then 99999999999999999999999999999.123456 when 1 then -99999999999999999999.654321 else n * 1000000000000.000001 end,
    case mod(n, 7) when 0 then null when 1 then -9999999999 when 2 then 9999999999 else n end
  from (select level as n from db_root connect by level <= 5000) x;
select count(*), count(n1), count(n8), count(n9), count(n16), count(n0) from t_num;
select sum(n1), cast(avg(n1) as numeric(38,4)), min(n1), max(n1) from t_num;
select sum(n8), cast(avg(n8) as numeric(38,4)), min(n8), max(n8) from t_num;
select sum(n9), cast(avg(n9) as numeric(38,4)), min(n9), max(n9) from t_num;
select sum(n16), cast(avg(n16) as numeric(38,4)), count(n16) from t_num;
select sum(n8), cast(avg(n8) as numeric(38,4)), count(n8) from t_num where n8 < 24;
select sum(n8), cast(avg(n8) as numeric(38,4)) from t_num where n8 >= 24 and n8 < 24000;
select sum(n1), sum(n8), sum(n9), sum(n16) from t_num where mod(id, 2) = 0;
select sum(n1 + n8), avg(n8 * 2), sum(n9 - n1) from t_num where id < 3000;
select sum(n16) from t_num where n16 > 0;

evaluate 'Case 2: NUMERIC leaf constants of 1..15 digits, at, below and beyond the column''s scale and width';
select count(*) from t_num where n8 < 5;
select count(*) from t_num where n8 < 24;
select count(*) from t_num where n8 = 240;
select count(*) from t_num where n8 <> 4800.000;
select count(*) from t_num where n8 < 12345678.9999;
select count(*) from t_num where n8 < 1234567890.12;
select count(*) from t_num where n8 > 123456789012.345;
select count(*) from t_num where n8 < 1234567890123;
select count(*) from t_num where n8 < 123456789012345;
select count(*) from t_num where n8 < 999999999999999.9995;
select count(*) from t_num where n1 < 1.2345;
select count(*) from t_num where n1 = 1.50;
select count(*) from t_num where n1 >= 99999.99;
select count(*) from t_num where n0 > 99999999999999999999;
select count(*) from t_num where n0 < -99999999999999999999;
select count(*) from t_num where n16 = 99999999999999999999999999999.123456;
select count(*) from t_num where n9 < 1234567890123456.7891 and n9 > (0 - 1);

evaluate 'Case 3: a CHAR(300) column: the batch cannot read most of its records and hands the pages back, until it gives up';
drop table if exists t_c300;
create table t_c300 (id int, c300 char(300), v10 varchar(10));
insert into t_c300 select n, 'ab' || mod(n, 10), 'ab' || mod(n, 10) from (select level as n from db_root connect by level <= 5000) x;
select count(*) from t_c300 where c300 = 'ab1';
select count(*) from t_c300 where c300 like '%b1';
select count(*) from t_c300 where v10 = 'ab1' and c300 like 'ab1%';

drop table t_num, t_c300;
