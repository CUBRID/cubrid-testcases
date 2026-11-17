/**
 *  This test case verifies CBRD-27361: a heap scan's filter and its NUMERIC operand steps run a page at a time
 *  (the page batch), and the batch's comparison leaves and its NUMERIC ADD, SUB and MUL steps must give the row
 *  path's answers.  The leaves decide their operator once per chunk and keep a row by its result; a NUMERIC step
 *  computes on the signed coefficients of its operands (cubrid#8196 0efc06bf1).
 *
 *  Coverage:
 *    Case 1: NUMERIC steps: a product with a zero operand (the scale-0 zero), sums and differences of mixed scales
 *            (the narrower operand raised by a power of ten), a difference that reaches zero, NULL operands, an
 *            integer operand, NUMERIC(38) operands near 38 digits, and the same steps grouped
 *    Case 2: comparison leaves over NUMERIC columns: every operator, a constant finer than the column's scale
 *            (every row has the same result), negative constants, a NULL host variable
 *    Case 3: comparison leaves over INTEGER, BIGINT and DOUBLE columns, and a filter chaining them
 */


evaluate 'Case 1: NUMERIC steps over the batch: zero products, mixed scales, NULLs, integers, NUMERIC(38)';
drop table if exists t_bk;
create table t_bk (id int, i int, b bigint, d double, p numeric(15,2), q numeric(15,2), w numeric(38,10), z numeric(38,0));
insert into t_bk
  select n,
    case when mod(n, 17) = 0 then null else mod(n * 7919, 2001) - 1000 end,
    case when mod(n, 19) = 0 then null else (mod(n * 104729, 20001) - 10000) * 1000003 end,
    case when mod(n, 23) = 0 then null else (mod(n * 31, 1001) - 500) / 8.0 end,
    case when mod(n, 13) = 0 then null when mod(n, 29) = 0 then 0 else (mod(n * 7907, 200001) - 100000) / 100.0 end,
    case when mod(n, 11) = 0 then null when mod(n, 31) = 0 then 0 else (mod(n * 6113, 2001) - 1000) / 100.0 end,
    case when mod(n, 37) = 0 then null else (mod(n * 3571, 2000001) - 1000000) / 1000.0 end,
    case when mod(n, 41) = 0 then null
         when mod(n, 43) = 0 then 9999999999999999999999999999999999990 * (case when mod(n, 2) = 0 then 1 else -1 end)
         else mod(n * 977, 100001) - 50000 end
  from (select cast (level as bigint) as n from db_root connect by level <= 5000) x;
select count(*), sum(p * q), sum(p * (1 - q)), sum(p + q), sum(p - q), sum(q - q), sum(p * 0), sum((p - p) * q),
       sum(p + 1.5), sum(p - 0.125), sum(q * 2.5) from t_bk where id > 0;
select count(*), sum(w * p), sum(w - p), sum(w + q * 3), sum(z * 10), sum(z + p) from t_bk where id > 0;
select count(*), sum(i * p), sum(b * q), sum(p * i - q) from t_bk where id > 0;
select id, p * q, p * (1 - q), p + q, p - q, q - q, p * 0, w * p, z * 10, z + p from t_bk where id <= 120 order by id;
select mod(id, 7) g, count(*), sum(p * q), sum(p - q), sum(p * (1 + q)) from t_bk where id > 0 group by mod(id, 7) order by 1;


evaluate 'Case 2: comparison leaves over NUMERIC columns: every operator, a finer constant, negatives, a NULL host variable';
select count(*) from t_bk where p < 24;
select count(*) from t_bk where p <= -24.5;
select count(*) from t_bk where p = 0;
select count(*) from t_bk where p <> 0;
select count(*) from t_bk where p > 999.99;
select count(*) from t_bk where p >= -0.01;
select count(*) from t_bk where p = 2.345;
select count(*) from t_bk where p <> 2.345;
select count(*) from t_bk where p < 2.345;
select count(*) from t_bk where p > -2.345;
select count(*) from t_bk where w < 0.0000000001;
select count(*) from t_bk where z > 0;
select count(*) from t_bk where z = 9999999999999999999999999999999999990;
select count(*) from t_bk where q between -1.5 and 1.5;
prepare st from 'select count(*), sum(p) from t_bk where p < ?';
execute st using null;
execute st using 10;
deallocate prepare st;


evaluate 'Case 3: comparison leaves over INTEGER, BIGINT and DOUBLE columns, and a filter chaining them';
select count(*) from t_bk where i < 0;
select count(*) from t_bk where i = 7;
select count(*) from t_bk where i <> 7;
select count(*) from t_bk where b >= 0;
select count(*) from t_bk where b < -5000000000;
select count(*) from t_bk where d < 0.0e0;
select count(*) from t_bk where d <> 0.0e0;
select count(*) from t_bk where d = 0.0e0;
select count(*) from t_bk where d >= -1.5e0;
select count(*), sum(p) from t_bk where d > -3.0e0 and p < 100;
select count(*), sum(p), sum(q), min(p), max(q) from t_bk where p < 500 and q > -5 and i <> 3;
select id, p, q from t_bk where p < -999 and q >= 0 order by id;
drop table t_bk;
