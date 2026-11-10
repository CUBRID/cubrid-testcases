/**
 *  CBRD-27948: a CASE or DECODE chain with a constant-false branch followed by THEN NULL crashed the client
 *  during constant folding
 *
 *  A CASE with several branches is a chain of CASE nodes. When the result type of the chain is a type with
 *  a precision (NUMERIC, VARCHAR), the outer CASE gave the inner CASE nodes that type but no precision, and
 *  left a node whose THEN is NULL at its own type. Constant folding replaces a node whose condition is
 *  constant false with the rest of the chain, casting it to the type of the node, and read the missing
 *  precision. Now every node of the chain gets the result type and its precision.
 *
 *  t1 (k, ...) = one row with k = 'a', so every k = 'q' branch is false and the result comes from ELSE
 *
 *  Coverage:
 *  1    the reported simple CASE: NUMERIC result, constant-false WHEN, then THEN NULL
 *  2    searched CASE, simple CASE and DECODE with NUMERIC and SMALLINT, INTEGER, BIGINT branches
 *  3    VARCHAR result from CHAR, VARCHAR, BIT and ENUM with JSON branches
 *  4    THEN NULL before the constant-false branch, two constant-false branches, ELSE NULL, a column ELSE
 *  5    the result type and value are the same as when the condition is false only at run time
 *  6    forms that did not crash: no THEN NULL, no constant-false branch, INTEGER result
 *
 *  The result domain of a single-branch CASE was computed from its ELSE value before the value was cast to the
 *  result type, so THEN <varchar(10)> ELSE <json> got VARCHAR(10) and failed with "Data overflow" for a longer
 *  JSON value, and the result domain depended on the order of the branches. Now it is computed from the cast value.
 *
 *  t2 (k, v, c, j) = one row with k = 'a', v varchar (10), c char (5), j a JSON value of 26 characters
 *
 *  7    VARCHAR (10) and a longer JSON: single-branch CASE, simple CASE and DECODE, a WHEN ... THEN NULL branch,
 *       and a two-branch CASE return the JSON value instead of "Data overflow"
 *  8    the result domain of a single-branch CASE is the same with the branches in either order
 *
 *  9    more forms of the crash (from CBRD-27932): a NUMERIC result from an integer literal out of the BIGINT
 *       range, the expression in WHERE, ORDER BY and INSERT ... SELECT, a nested CASE, and a simple CASE whose
 *       constant-false branch compares two integers
 */

drop table if exists t1, t2, t_fold, t_nofold, t_order, t_ins;
create table t1 (k varchar (10), i int, si smallint, bi bigint, n numeric (10, 2),
  c char (5), v varchar (10), b bit (8), e enum ('a', 'b'), j json);
insert into t1 values ('a', 1, 1, 1, 1.25, 'a', 'a', X'AB', 'a', '{"a":1}');


evaluate 'Case 1: the reported simple CASE';
select case 'q' when c then 1.5 when 'z' then 1 when c then null else 2 end from (select 'a' as c from db_root) x;


evaluate 'Case 2: NUMERIC with SMALLINT, INTEGER and BIGINT branches';
select case when k = 'q' then n when 1 = 0 then si when k = 'q' then null else si end from t1;
select case when k = 'q' then n when 1 = 0 then i when k = 'q' then null else i end from t1;
select case when k = 'q' then n when 1 = 0 then bi when k = 'q' then null else bi end from t1;
select case 'q' when k then 1.5 when 'z' then 1 when k then null else 2 end from t1;
select decode ('q', k, 1.5, 'z', 1, k, null, 2) from t1;
select decode ('q', k, n, 'z', bi, k, null, bi) from t1;


evaluate 'Case 3: VARCHAR result from CHAR, VARCHAR, BIT and ENUM with JSON branches';
select case when k = 'q' then c when 1 = 0 then j when k = 'q' then null else j end from t1;
select case when k = 'q' then v when 1 = 0 then j when k = 'q' then null else j end from t1;
select case when k = 'q' then b when 1 = 0 then j when k = 'q' then null else j end from t1;
select case when k = 'q' then e when 1 = 0 then j when k = 'q' then null else j end from t1;
select decode ('q', k, v, 'z', j, k, null, j) from t1;


evaluate 'Case 4: THEN NULL before the constant-false branch, two constant-false branches, ELSE NULL, a column ELSE';
select case when k = 'q' then 1.5 when k = 'q' then null when 1 = 0 then 1 when k = 'q' then null else 2 end from t1;
select case when k = 'q' then 1.5 when 1 = 0 then null when 1 = 0 then 1 when k = 'q' then null else 2 end from t1;
select case when k = 'q' then 1.5 when 1 = 0 then 1 when 1 = 0 then 2 when k = 'q' then null else 3 end from t1;
select case when k = 'q' then 1.5 when 1 = 0 then 1 when k = 'q' then null else null end from t1;
select case when k = 'q' then 1.5 when 1 = 0 then 1 when k = 'q' then null else i end from t1;
select case when k = 'q' then 1.5 when k = 'a' then 1 when 1 = 0 then 1 when k = 'q' then null else 2 end from t1;


evaluate 'Case 5: the same result type and value as a condition that is false only at run time';
create table t_fold as
  select case when k = 'q' then n when 1 = 0 then i when k = 'q' then null else 2 end as r1,
         case when k = 'q' then v when 1 = 0 then j when k = 'q' then null else j end as r2
  from t1;
create table t_nofold as
  select case when k = 'q' then n when k = 'z' then i when k = 'q' then null else 2 end as r1,
         case when k = 'q' then v when k = 'z' then j when k = 'q' then null else j end as r2
  from t1;
select * from t_fold;
select * from t_nofold;
select attr_name, data_type, prec, scale from db_attribute where class_name = 't_fold' order by attr_name;
select attr_name, data_type, prec, scale from db_attribute where class_name = 't_nofold' order by attr_name;


evaluate 'Case 6: forms that did not crash';
select case when k = 'q' then 1.5 when 1 = 0 then 1 else 2 end from t1;
select case when k = 'q' then 1.5 when k = 'q' then 1 when k = 'q' then null else 2 end from t1;
select case when k = 'q' then 1 when 1 = 0 then 1 when k = 'q' then null else 2 end from t1;
select case when k = 'q' then 1.5 when 1 = 0 then 1 when k = 'q' then 3 else 2 end from t1;


create table t2 (k varchar (10), v varchar (10), c char (5), j json);
insert into t2 values ('a', 'a', 'a', '{"key":"0123456789abcdef"}');


evaluate 'Case 7: VARCHAR (10) and a longer JSON return the JSON value';
select case when k = 'q' then v else j end from t2;
select case k when 'q' then v else j end from t2;
select decode (k, 'q', v, j) from t2;
select case when k = 'q' then v when k = 'z' then null else j end from t2;
select case when k = 'q' then v when k = 'z' then j else j end from t2;


evaluate 'Case 8: the result domain of a single-branch CASE does not depend on the order of the branches';
create table t_order as
  select case when k = 'q' then v else c end as r1,
         case when k = 'q' then c else v end as r2
  from t2;
select attr_name, data_type, prec, scale from db_attribute where class_name = 't_order' order by attr_name;

evaluate 'Case 9: more forms of the crash';
select case 'q' when k then 12345678901234567890 when 'z' then 1 when k then null else 2 end from t1;
select i from t1 where case 'q' when k then 1.5 when 'z' then 1 when k then null else 2 end = 2;
select k from t1 order by case 'q' when k then 1.5 when 'z' then 1 when k then null else 2 end;
create table t_ins (n numeric (10, 2));
insert into t_ins select case 'q' when k then 1.5 when 'z' then 1 when k then null else 2 end from t1;
select * from t_ins;
select case 'q' when k then 1.5 else case 'q' when k then 1.5 when 'z' then 1 when k then null else 2 end end from t1;
select case 1 when char_length (k) + 5 then 1.5 when 2 then 1 when char_length (k) then null else 2 end from t1;
drop table t1, t2, t_fold, t_nofold, t_order, t_ins;
