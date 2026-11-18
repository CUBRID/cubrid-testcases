/**
 *  This test case verifies CBRD-28175: A fixed NUMERIC converted to a floating NUMERIC, or rounded by
 *  ROUND/TRUNC/FLOOR/CEIL, keeps its declared precision instead of its digits and is stored larger than
 *  its value needs
 *
 *  A floating NUMERIC keeps its own precision, which is the number of digits of its coefficient, and its
 *  disk size follows that precision. A floating value made from a fixed one now takes the digits of its
 *  coefficient as its precision instead of the precision the fixed domain declares, so DISK_SIZE shows the
 *  size of its digits. Each case also prints the value, which stays the same.
 *
 *  Coverage:
 *    Case 1:  CAST to NUMERIC of a NUMERIC(38,2) column has the size of a literal of the same value
 *    Case 2:  ROUND, TRUNC, FLOOR and CEIL of a NUMERIC(38,2) column have the size of their digits
 *    Case 3:  expressions whose common type is a floating NUMERIC convert the fixed side by its digits
 *    Case 4:  UNION ALL and UNION with a floating NUMERIC column convert the fixed side by its digits
 *    Case 5:  a fixed value inserted or updated into a floating NUMERIC column is stored by its digits
 *    Case 6:  fixed columns of a negative scale and of scale 0 convert and round by their digits
 */

drop table if exists t_fix;
drop table if exists t_scale;
drop table if exists t_float;

-- y is a fixed NUMERIC(38,2) column and z a floating NUMERIC column
create table t_fix (y numeric(38,2), z numeric);
insert into t_fix values (1.55, 1.5);

create table t_scale (a numeric(38,-5), b numeric(38,0));
insert into t_scale values (1500000, 1500000);

evaluate 'Case 1: CAST to NUMERIC of a NUMERIC(38,2) column has the size of a literal of the same value';
select cast (y as numeric), disk_size (cast (y as numeric)), disk_size (cast (1.55 as numeric)), disk_size (y + 0) from t_fix;

evaluate 'Case 2: ROUND, TRUNC, FLOOR and CEIL of a NUMERIC(38,2) column have the size of their digits';
select round (y, 1), disk_size (round (y, 1)), trunc (y, 1), disk_size (trunc (y, 1)) from t_fix;
select floor (y), disk_size (floor (y)), ceil (y), disk_size (ceil (y)) from t_fix;

evaluate 'Case 3: expressions whose common type is a floating NUMERIC convert the fixed side by its digits';
select nvl (y, z), disk_size (nvl (y, z)), coalesce (y, z), disk_size (coalesce (y, z)) from t_fix;
select disk_size (case when z > 0 then y else z end), disk_size (decode (z, 1.5, y, z)), disk_size (greatest (y, z)) from t_fix;

evaluate 'Case 4: UNION ALL and UNION with a floating NUMERIC column convert the fixed side by its digits';
select v, disk_size (v) from (select y v from t_fix union all select z from t_fix) u order by v;
select v, disk_size (v) from (select y v from t_fix union select z from t_fix) u order by v;

evaluate 'Case 5: a fixed value inserted or updated into a floating NUMERIC column is stored by its digits';
create table t_float (id int, v numeric);
insert into t_float select 1, y from t_fix;
insert into t_float values (2, 0);
update t_float set v = (select y from t_fix) where id = 2;
select id, v, disk_size (v) from t_float order by id;

evaluate 'Case 6: fixed columns of a negative scale and of scale 0 convert and round by their digits';
select cast (a as numeric), disk_size (cast (a as numeric)), round (a, -6), disk_size (round (a, -6)), disk_size (floor (a)) from t_scale;
select cast (b as numeric), disk_size (cast (b as numeric)), disk_size (floor (b)), disk_size (ceil (b)) from t_scale;

drop table t_fix;
drop table t_scale;
drop table t_float;
