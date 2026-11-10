/**
 *  This test case verifies CBRD-28020: TRUNC of a BIGINT to a place at or left of the 19th digit returns 0, and the
 *  smallest BIGINT as the place no longer kills the server
 *
 *  TRUNC of a BIGINT divided the value by 10 to the power of minus the place. With the smallest BIGINT as the place,
 *  minus the place overflowed back to itself, the power came out 0 and the division by 0 raised SIGFPE: the server
 *  process died. Places of -19 and below converted 10^19 or more to BIGINT, which does not fit; the smallest BIGINT
 *  came back as itself. Such a place truncates every digit, so TRUNC returns 0.
 *
 *  Coverage:
 *    Case 1: the smallest BIGINT as the place, from another table, from the same row, and as a string
 *    Case 2: places -18 (digits kept), -19 and -400, the largest and smallest BIGINT among the values
 *    Case 3: forms that were right - an ordinary negative place, place 0, an INTEGER value
 */

drop table if exists t_28020, p_28020, i_28020;

create table t_28020 (b bigint);
insert into t_28020 values (-9223372036854775808), (9223372036854775807), (12345), (-12345), (0);
create table p_28020 (n bigint);
insert into p_28020 values (-9223372036854775808);
create table i_28020 (v int);
insert into i_28020 values (12345);

evaluate 'Case 1: the smallest BIGINT as the place; result = 0';
select t.b, trunc (t.b, p.n) from t_28020 t, p_28020 p order by t.b;
select trunc (b, b) from t_28020 where b < -100000;
select trunc (b, '-9223372036854775808') from t_28020 where b = 12345;

evaluate 'Case 2: places -18, -19 and -400';
select b, trunc (b, -18) from t_28020 order by b;
select b, trunc (b, -19) from t_28020 order by b;
select b, trunc (b, -400) from t_28020 order by b;

evaluate 'Case 3: an ordinary negative place, place 0, an INTEGER value';
select b, trunc (b, -2) from t_28020 order by b;
select trunc (b, 0) from t_28020 where b = 12345;
select trunc (v, -2) from i_28020;

drop table t_28020, p_28020, i_28020;
