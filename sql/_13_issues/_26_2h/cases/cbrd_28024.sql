/**
 *  This test case verifies CBRD-28024: WIDTH_BUCKET of a BIGINT or NUMERIC operand no longer divides by 0 when the
 *  width of a bucket is below the smallest NUMERIC, and gives the bucket count + 1 below a descending range
 *
 *  For a BIGINT or NUMERIC operand, WIDTH_BUCKET divided the operand's distance from the start of the range by the
 *  width of a bucket, (max - min) / count, in floating NUMERIC. A width below the smallest NUMERIC (scale 252) was
 *  rounded to 0 and the division by it raised SIGFPE: the server process died. A width just above that lost digits and
 *  gave a wrong bucket. The bucket is now the operand's fraction of the range times the count.
 *  In a descending range, an operand below the end of the range went through the formula instead of getting the
 *  count + 1 that a DOUBLE operand gets: a bucket past count + 1, or an overflow error when the operand was far below.
 *
 *  Coverage:
 *    Case 1: a range so small that the width of a bucket rounds to 0 - constants only, a BIGINT column ascending and
 *            descending, 2147483646 buckets, a NUMERIC column
 *    Case 2: a width near the smallest NUMERIC that lost digits
 *    Case 3: forms that were right - ascending bounds, between them and outside, BIGINT and NUMERIC (5, 1) beside
 *            DOUBLE; a range near the largest NUMERIC
 *    Case 4: a descending range, the operand below it included, BIGINT and NUMERIC (5, 1) beside DOUBLE; an operand
 *            far below the range, which overflowed
 */

drop table if exists d_28024, e_28024, n_28024;

create table d_28024 (b bigint);
insert into d_28024 values (-30), (-3), (0), (4), (6), (7);
create table e_28024 (x numeric (5, 1));
insert into e_28024 values (-3.0), (0.0), (0.1), (2.0), (4.5);
create table n_28024 (n numeric);
insert into n_28024 values (cast (1e-252 as numeric));

evaluate 'Case 1: the width of a bucket rounds to 0; result = 3, 3, 3, 1073741824, 3';
select width_bucket (cast (0 as bigint), cast (-1e-252 as numeric), cast (1e-252 as numeric), 5) as wb;
select width_bucket (b, cast (-1e-252 as numeric), cast (1e-252 as numeric), 5) as wb_asc,
       width_bucket (b, cast (1e-252 as numeric), cast (-1e-252 as numeric), 5) as wb_desc
  from d_28024 where b = 0;
select width_bucket (b, cast (-1e-244 as numeric), cast (1e-244 as numeric), 2147483646) as wb from d_28024 where b = 0;
select width_bucket (n, 0, cast (2e-252 as numeric), 5) as wb from n_28024;

evaluate 'Case 2: a width near the smallest NUMERIC; result = 4, 334';
select width_bucket (cast (2e-252 as numeric), 0, cast (3e-252 as numeric), 5) as wb5,
       width_bucket (cast (2e-250 as numeric), 0, cast (3e-250 as numeric), 500) as wb500;

evaluate 'Case 3: ascending, and a range near the largest NUMERIC; wb = wb_double, 500001';
select b, width_bucket (b, 0, 6, 9) as wb, width_bucket (cast (b as double), 0, 6, 9) as wb_double
  from d_28024 order by b;
select x, width_bucket (x, 0, 6, 9) as wb, width_bucket (cast (x as double), 0, 6, 9) as wb_double
  from e_28024 order by x;
select width_bucket (cast (1e250 as numeric), 0, cast (2e250 as numeric), 1000000) as wb_asc,
       width_bucket (cast (1e250 as numeric), cast (2e250 as numeric), 0, 1000000) as wb_desc;

evaluate 'Case 4: descending, below the range = count + 1 (10, then 11); wb = wb_double';
select b, width_bucket (b, 6, 0, 9) as wb, width_bucket (cast (b as double), 6, 0, 9) as wb_double
  from d_28024 order by b;
select x, width_bucket (x, 6, 0, 9) as wb, width_bucket (cast (x as double), 6, 0, 9) as wb_double
  from e_28024 order by x;
select width_bucket (cast (-1e20 as numeric), 5, 0, 10) as wb_num,
       width_bucket (cast (-9000000000000000000 as bigint), 5, 0, 10) as wb_big,
       width_bucket (cast (-1e20 as double), 5, 0, 10) as wb_double;

drop table d_28024, e_28024, n_28024;
