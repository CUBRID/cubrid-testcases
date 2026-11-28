/*
 * CBRD-28207: substituting an equality or a constant column of a derived table into other terms.
 *
 * Case 1: (x.b = 2 or w2.c = x.c) and x.b = 3 leaves the join term w2.c range (x.c =) once the
 * constant disjunct is folded away. It failed with System error (generate var), or with
 * "Outer join query optimization failed." for an outer join.
 * Case 2: a term on a constant column (5 as c) of a derived table that an outer join pads with NULL
 * was replaced by its copy with the constant (y.c = y.c became 5 = 5), so the NULL rows came back.
 */
drop table if exists t28207_w1, t28207_w2, t28207_q1, t28207_q2, t28207_r;
create table t28207_w1 (a int, b int, c int);
create table t28207_w2 (a int, b int, c int);
insert into t28207_w1 values (1, 3, 1), (2, 3, 5);
insert into t28207_w2 values (1, 0, 1), (2, 0, 2);
create table t28207_q1 (a int);
create table t28207_q2 (a int, b int);
create table t28207_r (a int);
insert into t28207_q1 values (1), (2), (5);
insert into t28207_q2 values (1, 1);
insert into t28207_r values (5);

-- Case 1: the join term left alone after the OR is folded
select x.a, w2.a from t28207_w2 w2 left join (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  on (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select x.a, w2.a from t28207_w2 w2 inner join (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  on (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select /*+ USE_HASH */ x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select /*+ USE_MERGE */ x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select x.a, w2.a from (select /*+ NO_MERGE */ a, b, c from t28207_w1) x right join t28207_w2 w2
  on (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c + 1) and x.b = 3 order by 1, 2;
with x as (select /*+ NO_MERGE */ a, b, c from t28207_w1)
  select x.a, w2.a from t28207_w2 w2, x where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
-- two disjuncts before the join term fold away
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or x.b = 4 or w2.c = x.c) and x.b = 3 order by 2;
-- the range intersection drops the constant range next to the join range
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where w2.c in (x.c, 7) and w2.c < 3 order by 2;
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (w2.c = x.c or w2.c = 5) and w2.c < 3 order by 2;
select x.a, w2.a from t28207_w2 w2 left join (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  on w2.c in (x.c, 7) and w2.c < 3 order by 2;
-- operands of other types, and DELETE
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, cast (c as varchar (10)) c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select /*+ USE_HASH */ x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, cast (c as double) c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
create table t28207_d (a int, b int, c int);
insert into t28207_d select * from t28207_w2;
delete d from t28207_d d, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x where (x.b = 2 or d.c = x.c) and x.b = 3;
select * from t28207_d order by 1;
drop table t28207_d;
-- the same query on a table, and an OR that is not folded
select /*+ USE_HASH */ x.a, w2.a from t28207_w2 w2, t28207_w1 x where (x.b = 2 or w2.c = x.c) and x.b = 3 order by 2;
select x.a, w2.a from t28207_w2 w2, (select /*+ NO_MERGE */ a, b, c from t28207_w1) x
  where (x.b = 2 or w2.c = x.c) and x.b > 1 order by 1, 2;

-- Case 2: a constant column of the NULL-padded side
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a where y.c = y.c order by 1;
select q1.a, y.c from t28207_q1 q1 left join (select a, 5 as c from t28207_q2) y
  on q1.a = y.a where y.c = y.c order by 1;
select q1.a, y.c from (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y right join t28207_q1 q1
  on q1.a = y.a where y.c = y.c order by 1;
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a where y.c = y.c + 0 order by 1;
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 'x' as c from t28207_q2) y
  on q1.a = y.a where y.c = y.c order by 1;
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a where y.c = q1.a order by 1;
-- HAVING without an aggregate goes to WHERE
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a group by q1.a, y.c having y.c = y.c order by 1;
-- the ON condition of a later join reads the NULL row too
select q1.a, y.c, z.a from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a left join t28207_r z on y.c = y.c order by 1;
select q1.a, y.c, z.a from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a left join t28207_r z on z.a = y.c order by 1;
-- a RIGHT OUTER after the LEFT OUTER, and UPDATE
select q1.a, y.c, q3.a from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a right join t28207_q1 q3 on q3.a = q1.a where y.c = y.c order by 3;
create table t28207_u (a int);
insert into t28207_u select a from t28207_q1;
update t28207_u u left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y on u.a = y.a
  set u.a = u.a + 100 where y.c = y.c;
select a from t28207_u order by 1;
drop table t28207_u;
-- its own ON condition, the ON condition of the RIGHT OUTER that pads it and an inner join read real rows only
select q1.a, y.c from (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y right join t28207_q1 q1
  on q1.a = y.a and q1.a = y.c order by 1;
select q1.a, y.c from t28207_q1 q1 left join (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  on q1.a = y.a and y.c = y.c order by 1;
select q1.a, y.c from t28207_q1 q1, (select /*+ NO_MERGE */ a, 5 as c from t28207_q2) y
  where q1.a = y.a and y.c = y.c order by 1;

drop table t28207_w1, t28207_w2, t28207_q1, t28207_q2, t28207_r;
