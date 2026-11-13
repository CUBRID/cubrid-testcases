/**
 *  This test case verifies CBRD-27243: Improve statement text printing for long value lists
 *
 *  The fix changed how the parser prints a statement back to text. An AND list, a VALUES list
 *  and the RANGE of a rewritten IN are collected in a local buffer and copied to the parser
 *  arena once. A plain string literal gets its text from the quoting function.
 *  The XASL cache key and the stored view definition are made from this text, so the text
 *  must not change: the output is the same on builds with and without the fix.
 *
 *  Printed forms read back:
 *    Query stmt:  the rewritten statement in the plan output (Case 1 to Case 4). It is printed
 *                 with the same printer and RANGE conversion as the XASL cache key, and only
 *                 this output prints the RANGE of a rewritten IN. CTP masks the digits of a plan.
 *    vclass_def:  the view definition stored in the catalog (Case 5 and Case 6). It is printed
 *                 without the rewrite.
 *
 *  Coverage:
 *    Case 1:  an OR term inside an AND list prints in parentheses
 *    Case 2:  a multi-column IN prints its RANGE as OR terms
 *    Case 3:  plain and decorated string literals print as written
 *    Case 4:  a VALUES list used as a query prints its rows in order
 *    Case 5:  a stored view prints its IN lists as written
 *    Case 6:  a stored view prints its string literals with charset and collation
 */

drop view if exists vb;
drop view if exists va;
drop table if exists ta;

-- Names and literals of plan queries hold no digits: CTP masks the digits of a plan.
create table ta (ca varchar(20), cb varchar(20), cc varchar(100));
insert into ta values ('a', 'a', 'x'), ('b', 'b', 'y');

-- Plan queries have the recompile hint: Query stmt prints only when the statement compiles,
-- and an earlier run on the same server may have cached the plan.

-- The CNF conversion leaves the OR as an or_next chain with no parentheses mark,
-- so the parentheses come from the AND list printer.
-- The OR names two columns because an OR on one column is rewritten into a RANGE (Case 2).
evaluate 'Case 1: an OR term inside an AND list prints in parentheses';
--@queryplan
select /*+ recompile */ * from ta
 where ca = 'a' and (cc = 'x' or cb = 'b') and cb <> 'zz';

evaluate 'Case 2: a multi-column IN prints its RANGE as OR terms';
--@queryplan
select /*+ recompile */ * from ta
 where (ca, cb) in (('a', 'a'), ('b', 'b'))
 order by ca;

-- The charset introducer, the cast, COLLATE and N are applied after the literal is made,
-- so every literal gets its text from the quoting function.
-- The printer builds only the COLLATE literal again from its value.
-- The backslash is a plain character: no_backslash_escapes is yes by default.
evaluate 'Case 3: plain and decorated string literals print as written';
--@queryplan
select /*+ recompile */ 'plain', _utf8'intro', cast('casted' as varchar(30)),
       'collated' collate utf8_en_ci, 'quote''inside', 'back\slash', N'national'
  from ta where ca = 'a';

evaluate 'Case 4: a VALUES list used as a query prints its rows in order';
--@queryplan
select /*+ recompile */ * from (values ('a', 'x'), ('b', 'y'), ('c', 'z')) tb (ca, cb)
 order by ca;

-- Query stmt prints an IN list as OR terms. The stored definition prints it as written.
evaluate 'Case 5: a stored view prints its IN lists as written';
create or replace view va (ca, cb) as
  select ca, cc from ta
   where ca in ('a', 'b', 'c') and cc in ('x', 'y');
select vclass_def from db_vclass where vclass_name = 'va';

-- The stored definition prints the charset and collation of each literal,
-- so the printer builds each literal again from its value.
-- Case 3 prints the same literals with their text from the quoting function.
evaluate 'Case 6: a stored view prints its string literals with charset and collation';
create or replace view vb (ca, cb, cc, cd, ce) as
  select 'plain', _utf8'intro', cast('casted' as varchar(30)),
         'quote''inside', N'national'
    from ta;
select vclass_def from db_vclass where vclass_name = 'vb';

drop view vb;
drop view va;
drop table ta;
