/**
 *  This test case verifies CBRD-27243: Improve statement text printing for long value lists
 *
 *  The parser prints each statement back to text, and that text is the key of the XASL
 *  cache and the stored definition of a view. The fix changed how the text is built:
 *  a VALUES list, an AND list and the RANGE of a rewritten IN collect their text in a
 *  temporary buffer and hand it to the parser arena once, and a plain string literal gets
 *  its printed text from the quoting function directly instead of from the whole tree printer.
 *  The printed text must stay the same byte for byte, so the output of this test case
 *  is the same on builds with and without the fix. It guards the new print paths.
 *
 *  Two printed forms are read back.
 *    Query stmt   - the rewritten statement in the plan output (Case 1 to Case 5).
 *                   It is printed like the XASL cache key and is the only output that
 *                   prints the RANGE of a rewritten IN. CTP masks its digits.
 *    vclass_def   - the view definition stored in the catalog (Case 6 to Case 8).
 *                   It is printed without the rewrite and is not masked.
 *
 *  Coverage:
 *    Case 1:  an AND list prints and between its terms only
 *    Case 2:  an OR term inside an AND list prints in parentheses
 *    Case 3:  a multi-column IN prints its RANGE as OR terms
 *    Case 4:  plain and decorated string literals print as written
 *    Case 5:  a VALUES list used as a query prints its rows in order
 *    Case 6:  a stored view keeps its AND list
 *    Case 7:  a stored view keeps its IN lists
 *    Case 8:  a stored view prints its string literals with charset and collation
 */

drop view if exists vc;
drop view if exists vb;
drop view if exists va;
drop table if exists ta;

-- No identifier or literal of a plan query holds a digit: CTP masks the digits of a plan.
create table ta (ca varchar(20), cb varchar(20), cc varchar(100));
insert into ta values ('a', 'a', 'x'), ('b', 'b', 'y');

-- Every plan query has the recompile hint: the plan and its Query stmt print only when
-- the statement compiles, and a plan cached by an earlier run on the same server would skip that.

evaluate 'Case 1: an AND list prints and between its terms only';
--@queryplan
select /*+ recompile */ * from ta
 where ca = 'a' and cc = 'x' and cb <> 'zz' and cc > 'a';

-- The CNF conversion turns the OR into an or_next chain whose nodes carry no parentheses mark,
-- so the parentheses in the output come from the AND list printer, not from the statement.
-- The OR names two columns: an OR on one column is rewritten into a RANGE, which Case 3 covers.
evaluate 'Case 2: an OR term inside an AND list prints in parentheses';
--@queryplan
select /*+ recompile */ * from ta
 where ca = 'a' and (cc = 'x' or cb = 'b') and cb <> 'zz';

-- The rewrite turns the multi-column IN into a RANGE, which prints as OR terms.
evaluate 'Case 3: a multi-column IN prints its RANGE as OR terms';
--@queryplan
select /*+ recompile */ * from ta
 where (ca, cb) in (('a', 'a'), ('b', 'b'))
 order by ca;

-- The charset introducer, the cast, the collation and N are attached after the literal is made,
-- so every literal here gets its text from the shortcut. The printer reads that text back, except
-- for the literal with COLLATE, which it builds again from its value. Case 8 builds all of them again.
-- 'back\slash' keeps the backslash as a plain character: no_backslash_escapes is yes by default.
evaluate 'Case 4: plain and decorated string literals print as written';
--@queryplan
select /*+ recompile */ 'plain', _utf8'intro', cast('casted' as varchar(30)),
       'collated' collate utf8_en_ci, 'quote''inside', 'back\slash', N'national'
  from ta where ca = 'a';

evaluate 'Case 5: a VALUES list used as a query prints its rows in order';
--@queryplan
select /*+ recompile */ * from (values ('a', 'x'), ('b', 'y'), ('c', 'z')) tb (ca, cb)
 order by ca;

evaluate 'Case 6: a stored view keeps its AND list';
create or replace view va (ca, cb) as
  select ca, cc from ta
   where ca = 'a' and cc = 'x' and cb <> 'zz' and cc > 'a';
select vclass_def from db_vclass where vclass_name = 'va';

-- Unlike Query stmt, the stored definition keeps the IN lists as IN lists.
evaluate 'Case 7: a stored view keeps its IN lists';
create or replace view vb (ca, cb) as
  select ca, cc from ta
   where ca in ('a', 'b', 'c') and cc in ('x', 'y');
select vclass_def from db_vclass where vclass_name = 'vb';

-- The stored definition prints the charset and the collation of each literal, so the tree printer
-- builds the literal text again from its value instead of reading the text that Case 4 shows.
evaluate 'Case 8: a stored view prints its string literals with charset and collation';
create or replace view vc (ca, cb, cc, cd, ce) as
  select 'plain', _utf8'intro', cast('casted' as varchar(30)),
         'quote''inside', N'national'
    from ta;
select vclass_def from db_vclass where vclass_name = 'vc';

drop view vc;
drop view vb;
drop view va;
drop table ta;
