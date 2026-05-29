/**
 * This test case verifies CBRD-25776: Add Inline CTE Support
 *
 * Coverage:
 *  1 - CTE without hint (default behavior)
 *  2 - CTE with INLINE hint (forced inline)
 *  3 - CTE with MATERIALIZE hint (forced materialize)
 *  4 - Recursive CTE - self-referencing (no recursive keyword)
 *  5 - Recursive CTE - with recursive keyword
 *  6 - Nested CTE: main query references CTE that references another CTE
 *  7 - Nested CTE: CTE referencing materialized CTE
 *  8 - Nested CTE: materialized CTE referencing another CTE
 *  9 - 3-level Nested CTE with materialize in middle
 * 10 - Multiple CTE references in main query (default materialize)
 * 11 - Multiple CTE references in main query + INLINE hint (forced inline)
 * 12 - Multiple CTE references in WITH clause to another CTE
 * 13 - Recursive CTE (with recursive) + INLINE hint (CTE materialized in trace)
 * 14 - Self-referencing CTE (with only) + INLINE hint (CTE materialized in trace)
 * 15 - CTE body containing ROWNUM + INLINE hint
 * 16 - CTE with QUERY_CACHE hint combined with INLINE hint (CTE materialized in trace)
 * 17 - Set operator UNION ALL: hint of left SELECT determines CTE strategy
 * 18 - View merge effect: INLINE enables index access / predicate pushdown
 */

drop table if exists ta, tb;
create table ta (ca int, cb int);
insert into ta values (1, 1);
insert into ta values (2, 2);
insert into ta values (3, 3);

set trace on;


-- ===========================================================================
-- Section 1: CTE without hint
-- ===========================================================================

evaluate '1.1 CTE without hint, create table [inline:Y]';
create table tb as
    with cte as (
        select * from ta
)select /*+ recompile */ * from cte;

show trace;

evaluate '1.2 CTE without hint, select [inline:Y]';
with cte as (
        select * from ta
)
select /*+ recompile */ * from cte;

show trace;

evaluate '1.3 CTE without hint, insert [inline:Y]';
insert into tb
    with  cte as (
        select * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '1.4 CTE without hint, update [inline:Y]';
with cte as (
        select * from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;

evaluate '1.5 CTE without hint, replace into [inline:Y]';
replace into tb
   with cte as (select * from ta)
   select /*+ recompile */ * from cte;

show trace;


evaluate '1.6 CTE without hint, delete [inline:Y]';
with cte as (
        select * from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 2: CTE with INLINE hint
-- ===========================================================================

evaluate '2.1 CTE with inline hint, create table [inline:Y]';
create table tb as
    with cte as (
        select /*+ inline */ * from ta
)select /*+ recompile */ * from cte;

show trace;


evaluate '2.2 CTE with inline hint, select [inline:Y]';
with cte as (
        select /*+ inline */ * from ta
)
select /*+ recompile */ * from cte;

show trace;


evaluate '2.3 CTE with inline hint, insert [inline:Y]';
insert into tb
    with  cte as (
        select /*+ inline */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '2.4 CTE with inline hint, update [inline:Y]';
with cte as (
        select /*+ inline */ * from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;

evaluate '2.5 CTE with inline hint, replace into [inline:Y]';
replace into tb
   with cte as (select /*+ inline */ * from ta)
   select /*+ recompile */ * from cte;

show trace;


evaluate '2.6 CTE with inline hint, delete [inline:Y]';
with cte as (
        select /*+ inline */ * from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 3: CTE with MATERIALIZE hint
-- ===========================================================================

evaluate '3.1 CTE with materialize hint, create table [inline:N]';
create table tb as
    with cte as (
        select /*+ materialize */ * from ta
)select /*+ recompile */ * from cte;

show trace;

evaluate '3.2 CTE with materialize hint, select [inline:N]';
with cte as (
        select /*+ materialize */ * from ta
)
select /*+ recompile */ * from cte;

show trace;

evaluate '3.3 CTE with materialize hint, insert [inline:N]';
insert into tb
    with  cte as (
        select /*+ materialize */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '3.4 CTE with materialize hint, update [inline:N]';
with cte as (
        select /*+ materialize */ * from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;


evaluate '3.5 CTE with materialize hint, replace into [inline:N]';
replace into tb
   with cte as (select /*+ materialize */ * from ta)
   select /*+ recompile */ * from cte;

show trace;


evaluate '3.6 CTE with materialize hint, delete [inline:N]';
with cte as (
        select /*+ materialize */ * from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 4: Recursive CTE - self-referencing (no recursive keyword)
-- ===========================================================================

evaluate '4.1 Recursive CTE - self-referencing, create table [inline:N]';
create table tb as
    with self_ref_cte as (
        select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '4.2 Recursive CTE - self-referencing, select [inline:N]';
with self_ref_cte as (
        select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)
select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '4.3 Recursive CTE - self-referencing, insert [inline:N]';
insert into tb with self_ref_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
) select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '4.4 Recursive CTE - self-referencing, update [inline:N]';
with self_ref_cte as (
        select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)update tb set ca = ca + 1 where ca in (select ca from self_ref_cte);

show trace;

evaluate '4.5 Recursive CTE - self-referencing, replace into [inline:N]';
replace into tb
with self_ref_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
) select /*+ recompile */ * from self_ref_cte;

show trace;


evaluate '4.6 Recursive CTE - self-referencing, delete [inline:N]';
with self_ref_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)
delete from tb where ca in (select ca from self_ref_cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 5: Recursive CTE - with recursive keyword
-- ===========================================================================

evaluate '5.1 Recursive CTE - with recursive keyword, create table [inline:N]';
create table tb as
    with recursive recursive_cte as (
        select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)select /*+ recompile */ * from recursive_cte;

show trace;


evaluate '5.2 Recursive CTE - with recursive keyword, select [inline:N]';
with recursive recursive_cte as (
        select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)
select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '5.3 Recursive CTE - with recursive keyword, insert [inline:N]';
insert into tb with recursive recursive_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
) select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '5.4 Recursive CTE - with recursive keyword, update [inline:N]';
with recursive recursive_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)update tb set ca = ca + 1 where ca in (select ca from recursive_cte);

show trace;

evaluate '5.5 Recursive CTE - with recursive keyword, replace into [inline:N]';
replace into tb
with recursive recursive_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
) select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '5.6 Recursive CTE - with recursive keyword, delete [inline:N]';
with recursive recursive_cte as (
    select 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)
delete from tb where ca in (select ca from recursive_cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 6: Nested CTE - main query using CTE that references another CTE
-- ===========================================================================

evaluate '6.1 Nested CTE reference - main query using CTE that references another CTE, create table [inline:Y]';
create table tb as
    with
        cte as (select * from ta),
        cte_b as (select * from cte)
    select /*+ recompile */ * from cte_b;

show trace;

evaluate '6.2 Nested CTE reference - main query using CTE that references another CTE, select [inline:Y]';
with
    cte as (select * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;


evaluate '6.3 Nested CTE reference - main query using CTE that references another CTE, insert [inline:Y]';
insert into tb with
    cte as (select * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '6.4 Nested CTE reference - main query using CTE that references another CTE, update [inline:Y]';
with
    cte as (select * from ta),
    cte_b as (select * from cte)
update tb set ca = ca + 1 where ca in (select ca from cte_b);

show trace;

evaluate '6.5 Nested CTE reference - main query using CTE that references another CTE, replace into [inline:Y]';
replace into tb with
    cte as (select * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '6.6 Nested CTE reference - main query using CTE that references another CTE, delete [inline:Y]';
with
    cte as (select * from ta),
    cte_b as (select * from cte)
delete from tb where ca in (select ca from cte_b);

show trace;

drop table tb;


-- ===========================================================================
-- Section 7: Nested CTE - CTE referencing materialized CTE
-- ===========================================================================

evaluate '7.1 Nested CTE reference - CTE referencing materialized CTE, create table [inline:N]';
create table tb as
    with
        cte as (select /*+ materialize */ * from ta),
        cte_b as (select * from cte)
    select /*+ recompile */ * from cte_b;

show trace;

evaluate '7.2 Nested CTE reference - CTE referencing materialized CTE, select [inline:N]';
with
    cte as (select /*+ materialize */ * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '7.3 Nested CTE reference - CTE referencing materialized CTE, insert [inline:N]';
insert into tb with
    cte as (select /*+ materialize */ * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '7.4 Nested CTE reference - CTE referencing materialized CTE, update [inline:N]';
with
    cte as (select /*+ materialize */ * from ta),
    cte_b as (select * from cte)
update tb set ca = ca + 1 where ca in (select ca from cte_b);

show trace;

evaluate '7.5 Nested CTE reference - CTE referencing materialized CTE, replace into [inline:N]';
replace into tb with
    cte as (select /*+ materialize */ * from ta),
    cte_b as (select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '7.6 Nested CTE reference - CTE referencing materialized CTE, delete [inline:N]';
with
    cte as (select /*+ materialize */ * from ta),
    cte_b as (select * from cte)
delete from tb where ca in (select ca from cte_b);

show trace;

drop table tb;


-- ===========================================================================
-- Section 8: Nested CTE - materialized CTE referencing another CTE
-- ===========================================================================

evaluate '8.1 Nested CTE reference - materialized CTE referencing another CTE, create table [inline:N]';
create table tb as
    with
        cte as (select * from ta),
        cte_b as (select /*+ materialize */ * from cte)
    select /*+ recompile */ * from cte_b;

show trace;

evaluate '8.2 Nested CTE reference - materialized CTE referencing another CTE, select [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte)
select /*+ recompile */ * from cte_b;

show trace;


evaluate '8.3 Nested CTE reference - materialized CTE referencing another CTE, insert [inline:N]';
insert into tb with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '8.4 Nested CTE reference - materialized CTE referencing another CTE, update [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte)
update tb set ca = ca + 1 where ca in (select ca from cte_b);

show trace;

evaluate '8.5 Nested CTE reference - materialized CTE referencing another CTE, replace into [inline:N]';
replace into tb with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '8.6 Nested CTE reference - materialized CTE referencing another CTE, delete [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte)
delete from tb where ca in (select ca from cte_b);

show trace;

drop table tb;


-- ===========================================================================
-- Section 9: 3-level Nested CTE with materialize in middle
-- ===========================================================================

evaluate '9.1 Nested CTE reference - materialized CTE referencing another CTE, create table [inline:N]';
create table tb as
    with
        cte as (select * from ta),
        cte_b as (select /*+ materialize */ * from cte),
        cte_c as (select * from cte_b)
    select /*+ recompile */ * from cte_c;

show trace;

evaluate '9.2 Nested CTE reference - materialized CTE referencing another CTE, select [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte),
    cte_c as (select * from cte_b)
select /*+ recompile */ * from cte_c;

show trace;

evaluate '9.3 Nested CTE reference - materialized CTE referencing another CTE, insert [inline:N]';
insert into tb with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte),
    cte_c as (select * from cte_b)
select /*+ recompile */ * from cte_c;

show trace;

evaluate '9.4 Nested CTE reference - materialized CTE referencing another CTE, update [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte),
    cte_c as (select * from cte_b)
update tb set ca = ca + 1 where ca in (select ca from cte_c);

show trace;

evaluate '9.5 Nested CTE reference - materialized CTE referencing another CTE, replace into [inline:N]';
replace into tb with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte),
    cte_c as (select * from cte_b)
select /*+ recompile */ * from cte_c;

show trace;

evaluate '9.6 Nested CTE reference - materialized CTE referencing another CTE, delete [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select /*+ materialize */ * from cte),
    cte_c as (select * from cte_b)
delete from tb where ca in (select ca from cte_c);

show trace;

drop table tb;


-- ===========================================================================
-- Section 10: Multiple CTE references in main query (default materialize)
-- ===========================================================================

evaluate '10.1 Multiple CTE references - materialize processing in main query, create table [inline:N]';
create table tb as
    with
        cte as (select * from ta)
    select /*+ recompile */ * from cte union all select * from cte;

show trace;


evaluate '10.2 Multiple CTE references - materialize processing in main query, select [inline:N]';
with
    cte as (select * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '10.3 Multiple CTE references - materialize processing in main query, insert [inline:N]';
insert into tb with
    cte as (select * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '10.4 Multiple CTE references - materialize processing in main query, update [inline:N]';
with
    cte as (select * from ta)
update tb set ca = ca + 1 where ca in (select ca from cte union all select ca from cte);

show trace;

evaluate '10.5 Multiple CTE references - materialize processing in main query, replace into [inline:N]';
replace into tb with
    cte as (select * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;


evaluate '10.6 Multiple CTE references - materialize processing in main query, delete [inline:N]';
with
    cte as (select * from ta)
delete from tb where ca in (select ca from cte union all select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 11: Multiple CTE references + INLINE hint (forced inline)
-- ===========================================================================

evaluate '11.1 Multiple CTE references - forced inlining with inline hint, create table [inline:Y]';
create table tb as
    with
        cte as (select /*+ inline */ * from ta)
    select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '11.2 Multiple CTE references - forced inlining with inline hint, select [inline:Y]';
with
    cte as (select /*+ inline */ * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '11.3 Multiple CTE references - forced inlining with inline hint, insert [inline:Y]';
insert into tb with
    cte as (select /*+ inline */ * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '11.4 Multiple CTE references - forced inlining with inline hint, update [inline:Y]';
with
    cte as (select /*+ inline */ * from ta)
update tb set ca = ca + 1 where ca in (select ca from cte union all select ca from cte);

show trace;

evaluate '11.5 Multiple CTE references - forced inlining with inline hint, replace into [inline:Y]';
replace into tb with
    cte as (select /*+ inline */ * from ta)
select /*+ recompile */ * from cte union all select * from cte;

show trace;

evaluate '11.6 Multiple CTE references - forced inlining with inline hint, delete [inline:Y]';
with
    cte as (select /*+ inline */ * from ta)
delete from tb where ca in (select ca from cte union all select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 12: Multiple references in WITH clause to another CTE
-- ===========================================================================

evaluate '12.1 Multiple CTE references - multiple references to another CTE in WITH clause, create table [inline:N]';
create table tb as
    with
        cte as (select * from ta),
        cte_b as (select * from cte union all select * from cte)
    select /*+ recompile */ * from cte_b;

show trace;

evaluate '12.2 Multiple CTE references - multiple references to another CTE in WITH clause, select [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select * from cte union all select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '12.3 Multiple CTE references - multiple references to another CTE in WITH clause, insert [inline:N]';
insert into tb with
    cte as (select * from ta),
    cte_b as (select * from cte union all select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '12.4 Multiple CTE references - multiple references to another CTE in WITH clause, update [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select * from cte union all select * from cte)
update tb set ca = ca + 1 where ca in (select ca from cte_b);

show trace;

evaluate '12.5 Multiple CTE references - multiple references to another CTE in WITH clause, replace into [inline:N]';
replace into tb with
    cte as (select * from ta),
    cte_b as (select * from cte union all select * from cte)
select /*+ recompile */ * from cte_b;

show trace;

evaluate '12.6 Multiple CTE references - multiple references to another CTE in WITH clause, delete [inline:N]';
with
    cte as (select * from ta),
    cte_b as (select * from cte union all select * from cte)
delete from tb where ca in (select ca from cte_b);

show trace;

drop table tb;


-- ===========================================================================
-- Section 13: Recursive CTE (with recursive) + INLINE hint forced
--             Expected: INLINE is ignored, CTE remains MATERIALIZE.
-- ===========================================================================

evaluate '13.1 Recursive CTE with recursive keyword + inline hint forced, create table [inline:N]';
create table tb as
    with recursive recursive_cte as (
        select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '13.2 Recursive CTE with recursive keyword + inline hint forced, select [inline:N]';
with recursive recursive_cte as (
        select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)
select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '13.3 Recursive CTE with recursive keyword + inline hint forced, insert [inline:N]';
insert into tb with recursive recursive_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
) select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '13.4 Recursive CTE with recursive keyword + inline hint forced, update [inline:N]';
with recursive recursive_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)update tb set ca = ca + 1 where ca in (select ca from recursive_cte);

show trace;

evaluate '13.5 Recursive CTE with recursive keyword + inline hint forced, replace into [inline:N]';
replace into tb
with recursive recursive_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
) select /*+ recompile */ * from recursive_cte;

show trace;

evaluate '13.6 Recursive CTE with recursive keyword + inline hint forced, delete [inline:N]';
with recursive recursive_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from recursive_cte where ca < 10
)
delete from tb where ca in (select ca from recursive_cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 14: Self-referencing CTE (with only) + INLINE hint forced
--             Expected: INLINE is ignored, CTE remains MATERIALIZE.
-- ===========================================================================

evaluate '14.1 Self-referencing CTE without recursive keyword + inline hint forced, create table [inline:N]';
create table tb as
    with self_ref_cte as (
        select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '14.2 Self-referencing CTE without recursive keyword + inline hint forced, select [inline:N]';
with self_ref_cte as (
        select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)
select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '14.3 Self-referencing CTE without recursive keyword + inline hint forced, insert [inline:N]';
insert into tb with self_ref_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
) select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '14.4 Self-referencing CTE without recursive keyword + inline hint forced, update [inline:N]';
with self_ref_cte as (
        select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)update tb set ca = ca + 1 where ca in (select ca from self_ref_cte);

show trace;

evaluate '14.5 Self-referencing CTE without recursive keyword + inline hint forced, replace into [inline:N]';
replace into tb
with self_ref_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
) select /*+ recompile */ * from self_ref_cte;

show trace;

evaluate '14.6 Self-referencing CTE without recursive keyword + inline hint forced, delete [inline:N]';
with self_ref_cte as (
    select /*+ inline */ 1 as ca
        union all
        select ca + 1 as ca from self_ref_cte where ca < 10
)
delete from tb where ca in (select ca from self_ref_cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 15: CTE body containing ROWNUM + INLINE hint (current rewriter)
-- The PR commit 24363d3 ("temporarily prevent inlining ... ROWNUM") was
-- relaxed; in CUBRID 11.5 the optimizer still inlines such CTEs. The trace
-- captured here is the live behavior reference for future regression checks.
-- ===========================================================================

evaluate '15.1 CTE with ROWNUM + inline hint, create table [inline:Y]';
create table tb as
    with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
)select /*+ recompile */ * from cte;

show trace;

evaluate '15.2 CTE with ROWNUM + inline hint, select [inline:Y]';
with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
)
select /*+ recompile */ * from cte;

show trace;

evaluate '15.3 CTE with ROWNUM + inline hint, insert [inline:Y]';
insert into tb with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '15.4 CTE with ROWNUM + inline hint, update [inline:Y]';
with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;

evaluate '15.5 CTE with ROWNUM + inline hint, replace into [inline:Y]';
replace into tb
with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '15.6 CTE with ROWNUM + inline hint, delete [inline:Y]';
with cte as (
        select /*+ inline */ rownum as r, ca, cb from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 16: CTE with QUERY_CACHE hint combined with INLINE hint
-- PR commit debd6b8 prevents inlining when query_cache is present.
-- ===========================================================================

evaluate '16.1 CTE with query_cache + inline hint, create table [inline:N]';
create table tb as
    with cte as (
        select /*+ inline query_cache */ * from ta
)select /*+ recompile */ * from cte;

show trace;

evaluate '16.2 CTE with query_cache + inline hint, select [inline:N]';
with cte as (
        select /*+ inline query_cache */ * from ta
)
select /*+ recompile */ * from cte;

show trace;

evaluate '16.3 CTE with query_cache + inline hint, insert [inline:N]';
insert into tb with cte as (
        select /*+ inline query_cache */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '16.4 CTE with query_cache + inline hint, update [inline:N]';
with cte as (
        select /*+ inline query_cache */ * from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;

evaluate '16.5 CTE with query_cache + inline hint, replace into [inline:N]';
replace into tb
with cte as (
        select /*+ inline query_cache */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '16.6 CTE with query_cache + inline hint, delete [inline:N]';
with cte as (
        select /*+ inline query_cache */ * from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 17: Set operator UNION ALL inside CTE - hint of left SELECT wins
--   17.1, 17.2 : variant A - left INLINE        -> INLINE applied
--   17.3, 17.4 : variant B - right INLINE only  -> default rule (materialize)
--   17.5, 17.6 : variant C - left MATERIALIZE   -> MATERIALIZE applied
-- ===========================================================================

evaluate '17.1 UNION ALL - left INLINE, create table [inline:Y]';
create table tb as
    with cte as (
        select /*+ inline */ * from ta
        union all
        select * from ta
)select /*+ recompile */ * from cte;

show trace;

evaluate '17.2 UNION ALL - left INLINE, select [inline:Y]';
with cte as (
        select /*+ inline */ * from ta
        union all
        select * from ta
)
select /*+ recompile */ * from cte;

show trace;

evaluate '17.3 UNION ALL - right INLINE only (left default), insert [inline:Y]';
insert into tb with cte as (
        select * from ta
        union all
        select /*+ inline */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '17.4 UNION ALL - right INLINE only (left default), update [inline:Y]';
with cte as (
        select * from ta
        union all
        select /*+ inline */ * from ta
)update tb set ca = ca + 1 where ca in (select ca from cte);

show trace;

evaluate '17.5 UNION ALL - left MATERIALIZE, right INLINE, replace into [inline:N]';
replace into tb
with cte as (
        select /*+ materialize */ * from ta
        union all
        select /*+ inline */ * from ta
) select /*+ recompile */ * from cte;

show trace;

evaluate '17.6 UNION ALL - left MATERIALIZE, right INLINE, delete [inline:N]';
with cte as (
        select /*+ materialize */ * from ta
        union all
        select /*+ inline */ * from ta
)
delete from tb where ca in (select ca from cte);

show trace;

drop table tb;


-- ===========================================================================
-- Section 18: View merge effect - INLINE enables index access / pushdown
-- Reproduces the JIRA description scenario: inlining lets the optimizer
-- push the predicate down through the CTE and use the underlying index.
-- ===========================================================================

set trace off;

drop table if exists tx;
create table tx (ca int, cb int, cc int, cd int);
create index ix_ca on tx(ca);

insert into tx
    select rownum, mod(rownum, 10), mod(rownum, 100), mod(rownum, 1000)
    from db_class a, db_class b limit 1000;

set trace on;

evaluate '18.1 View merge - INLINE pushes predicate to indexed table, create table [inline:Y]';
create table tb as
    with cte as (select /*+ inline */ * from tx)
    select /*+ recompile */ ca from cte where ca <= 100;

show trace;

evaluate '18.2 View merge - INLINE pushes predicate to indexed table, select [inline:Y]';
with cte as (select /*+ inline */ * from tx)
select /*+ recompile */ ca from cte where ca <= 100;

show trace;

evaluate '18.3 View merge - INLINE pushes predicate to indexed table, insert [inline:Y]';
insert into tb
    with cte as (select /*+ inline */ * from tx)
    select /*+ recompile */ ca from cte where ca <= 100;

show trace;

evaluate '18.4 View merge - INLINE pushes predicate to indexed table, update [inline:Y]';
with cte as (select /*+ inline */ * from tx)
update tb set ca = ca + 1
where ca in (select ca from cte where ca <= 100);

show trace;

evaluate '18.5 View merge - INLINE pushes predicate to indexed table, replace into [inline:Y]';
replace into tb
with cte as (select /*+ inline */ * from tx)
select /*+ recompile */ ca from cte where ca <= 100;

show trace;

evaluate '18.6 View merge - INLINE pushes predicate to indexed table, delete [inline:Y]';
with cte as (select /*+ inline */ * from tx)
delete from tb where ca in (select ca from cte where ca <= 100);

show trace;

drop table tb;
drop table tx;


-- ===========================================================================
-- Cleanup
-- ===========================================================================

drop table if exists ta, tb, tx;

set trace off;
