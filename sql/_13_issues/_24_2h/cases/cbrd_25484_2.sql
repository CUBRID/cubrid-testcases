
--This test case verifies the following issue: CBRD-25484.
--Validate when using inner joins and Oracle style outer joins together, errors no longer occur depending on the order of the join conditions.

/* ----------------------------------------
* The left spec in the join is referred to as left_tbl, and the right spec as right_tbl.
* In the scenario below, the point at which the join_type of the spec located on the right is checked 
* is when converting the Oracle-style outer join between left_tbl and right_tbl to an ANSI join.
*
*   1. The join_type of the spec located on the right, which is being converted to an ANSI join, is PT_JOIN_NONE.
*   2. The join_type of the spec located on the right, which is being converted to an ANSI join, is not PT_JOIN_NONE.
*
* This file covers test cases for item 2.
* When considering the join_type of the spec located between left_tbl and right_tbl, the first spec joined with right_tbl is not considered.
* ---------------------------------------- */
drop if exists tbl_a, tbl_b, tbl_c, left_tbl, right_tbl;

create table tbl_a (col_a int);
create table tbl_b (col_a int);
create table tbl_c (col_a int);
create table left_tbl (col_a int);
create table right_tbl (col_a int);

evaluate '1. Spec with only left_tbl and right_tbl, and no other table specs with a join relationship';
-- Only left_tbl and right_tbl with a spec for an outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt where t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '2. Spec with join_type == PT_JOIN_NONE is on the left side of left_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from tbl_a t_a, left_tbl lt, tbl_b t_b, right_tbl rt where t_b.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+) and t_a.col_a = lt.col_a;

evaluate '3. Spec with join_type == PT_JOIN_NONE is on the left side of left_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from tbl_a t_a, left_tbl lt, tbl_b t_b, right_tbl rt where t_b.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+);

evaluate '4. Spec with join_type == PT_JOIN_NONE is on the left side of left_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from tbl_a t_a, left_tbl lt, tbl_b t_b, right_tbl rt where t_b.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+) and t_a.col_a(+) = lt.col_a;

evaluate '5. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE are on the left side of left_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from tbl_a t_a, tbl_b t_b, left_tbl lt, tbl_c t_c, right_tbl rt where t_c.col_a(+) = rt.col_a and t_a.col_a(+) = t_b.col_a and lt.col_a(+) = rt.col_a and t_a.col_a = rt.col_a;

evaluate '6. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE are on the left side of left_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from tbl_a t_a, tbl_b t_b, left_tbl lt, tbl_c t_c, right_tbl rt where t_c.col_a(+) = rt.col_a and t_a.col_a = t_b.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '7. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE are on the left side of left_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from tbl_a t_a, tbl_b t_b, left_tbl lt, tbl_c t_c, right_tbl rt where t_c.col_a(+) = rt.col_a and t_a.col_a = t_b.col_a(+) and lt.col_a(+) = rt.col_a and t_a.col_a = lt.col_a(+);

evaluate '8. Spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, right_tbl rt where t_b.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_a.col_a = rt.col_a;

evaluate '9. Spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, right_tbl rt where t_b.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '10. Spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, right_tbl rt where t_b.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_a.col_a(+) = t_b.col_a;

evaluate '11. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where t_a.col_a = t_b.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_a.col_a = t_c.col_a;

evaluate '12. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where t_a.col_a = t_b.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '13. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where t_a.col_a = t_b.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_c.col_a(+) = t_b.col_a;

evaluate '14. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where lt.col_a = t_a.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_b.col_a = rt.col_a;

evaluate '15. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where lt.col_a = t_a.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '16. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is between left_tbl and right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where lt.col_a = t_a.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_b.col_a(+) = rt.col_a;

evaluate '17. Spec with join_type != PT_JOIN_NONE is between left_tbl and right_tbl';
-- No PT_JOIN_NONE spec here
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, tbl_b t_b, tbl_c t_c, right_tbl rt where t_a.col_a = t_b.col_a(+) and lt.col_a = t_a.col_a(+) and t_c.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '18. Spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b where t_a.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+) and t_b.col_a = lt.col_a;

evaluate '19. Spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b where t_a.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+);

evaluate '20. Spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b where t_a.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+) and t_b.col_a(+) = lt.col_a;

evaluate '21. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where t_b.col_a = t_c.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_b.col_a = t_a.col_a;

evaluate '22. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where t_b.col_a = t_c.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '23. Spec with join_type == PT_JOIN_NONE and another spec with join_type != PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where t_b.col_a(+) = t_c.col_a and t_a.col_a(+) = rt.col_a and lt.col_a = rt.col_a(+) and t_b.col_a(+) = lt.col_a;
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where t_b.col_a = t_c.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_b.col_a(+) = t_a.col_a;
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where t_b.col_a = t_c.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_b.col_a(+) = rt.col_a;


evaluate '24. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means an inner join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where rt.col_a = t_b.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a and t_c.col_a = t_b.col_a;

evaluate '25. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE means a cross join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where rt.col_a = t_b.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

evaluate '26. Spec with join_type != PT_JOIN_NONE and another spec with join_type == PT_JOIN_NONE is on the right side of right_tbl';
-- PT_JOIN_NONE represents an unhandled Oracle-style outer join
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where rt.col_a = t_b.col_a(+) and t_a.col_a(+) = rt.col_a and lt.col_a(+) = rt.col_a and t_c.col_a = lt.col_a(+);
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b, tbl_c t_c where rt.col_a(+) = t_b.col_a and t_a.col_a(+) = rt.col_a and lt.col_a(+) = rt.col_a and t_c.col_a(+) = lt.col_a;

evaluate '27. Spec with join_type != PT_JOIN_NONE is on the right side of right_tbl';
-- No PT_JOIN_NONE spec here
select /*+ recompile */ 1 from left_tbl lt, tbl_a t_a, right_tbl rt, tbl_b t_b where rt.col_a = t_b.col_a(+) and t_a.col_a = rt.col_a(+) and lt.col_a(+) = rt.col_a;

drop if exists tbl_a, tbl_b, tbl_c, left_tbl, right_tbl;
