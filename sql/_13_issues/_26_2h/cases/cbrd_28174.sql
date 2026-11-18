/**
 *  This test case verifies CBRD-28174: A NUMERIC of a negative scale converted to BIGINT drops its scale
 *  and gives its coefficient
 *
 *  A NUMERIC of a negative scale keeps its coefficient and its scale, such as 1500000 in NUMERIC(38,-5)
 *  as the coefficient 15 and the scale -5. Converting it to BIGINT now multiplies the coefficient by
 *  10 to the power of the negated scale, as the conversion to INTEGER does, and fails with an overflow
 *  error past the BIGINT range.
 *
 *  Coverage:
 *    Case 1:  NUMERIC(38,-5) and NUMERIC(10,-2) columns convert to the same BIGINT as INTEGER
 *    Case 2:  a negative value keeps its sign
 *    Case 3:  values next to the BIGINT maximum and minimum convert
 *    Case 4:  values past the BIGINT maximum and minimum fail with an overflow error
 *    Case 5:  a scale of -18 converts, and a scale of -19 or less fails with an overflow error
 *    Case 6:  zero converts to zero for any negative scale
 *    Case 7:  inserting a NUMERIC of a negative scale into a BIGINT column stores the value
 */

drop table if exists t_neg_scale;
drop table if exists t_big;

create table t_neg_scale (id int, n5 numeric(38,-5), n2 numeric(10,-2), n20 numeric(38,-20));
insert into t_neg_scale values (1, 1500000, 1200, 100000000000000000000);
insert into t_neg_scale values (2, -1500000, -1200, 0);

evaluate 'Case 1: NUMERIC(38,-5) and NUMERIC(10,-2) columns convert to the same BIGINT as INTEGER';
select id, cast (n5 as bigint), cast (n5 as int), cast (n2 as bigint), cast (n2 as int) from t_neg_scale where id = 1;

evaluate 'Case 2: a negative value keeps its sign';
select id, cast (n5 as bigint), cast (n2 as bigint) from t_neg_scale where id = 2;

evaluate 'Case 3: values next to the BIGINT maximum and minimum convert';
select cast (cast (9223372036854775800 as numeric(38,-2)) as bigint);
select cast (cast (-9223372036854775800 as numeric(38,-2)) as bigint);

evaluate 'Case 4: values past the BIGINT maximum and minimum fail with an overflow error';
select cast (cast (9223372036854775900 as numeric(38,-2)) as bigint);
select cast (cast (-9223372036854775900 as numeric(38,-2)) as bigint);
select cast (n20 as bigint) from t_neg_scale where id = 1;

evaluate 'Case 5: a scale of -18 converts, and a scale of -19 or less fails with an overflow error';
select cast (cast (9000000000000000000 as numeric(38,-18)) as bigint);
select cast (cast (10000000000000000000 as numeric(38,-19)) as bigint);

evaluate 'Case 6: zero converts to zero for any negative scale';
select cast (n20 as bigint), cast (cast (0 as numeric(38,-30)) as bigint) from t_neg_scale where id = 2;

evaluate 'Case 7: inserting a NUMERIC of a negative scale into a BIGINT column stores the value';
create table t_big (id int, b bigint);
insert into t_big select id, n5 from t_neg_scale;
select id, b from t_big order by id;

drop table t_neg_scale;
drop table t_big;
