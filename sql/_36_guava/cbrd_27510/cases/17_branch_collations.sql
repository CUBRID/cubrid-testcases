/**
 *  This test case verifies CBRD-27510: the gate decides the collation of every string, including the branch a row
 *  picks.
 *
 *  ELT returns one of its arguments by an index. When the index comes from the row and the branches are binds or
 *  session variables of different collations, develop labelled each row's value with the collation of the branch
 *  that row picked, and the first row's branch decided the collation that a sort, a DISTINCT or a comparison used.
 *  CBRD-27510 decides every string collation at the gate (qexec_resolve_domains, before the first row). For ELT
 *  whose index the row gives, the branch collations are merged into one domain for the statement and every picked
 *  value takes it, as MySQL does for ELT.
 *
 *  The new answers are in Case 2 and Case 3. In Case 2 every row carries the merged collation utf8_en_ci. develop
 *  gave the rows that picked the session variable utf8_bin, sorted by the first row's branch and kept 'b' and 'B'
 *  apart under DISTINCT. In Case 3 the branches do not merge (utf8_en_ci against utf8_en_cs), which is -1150 before
 *  any row, where develop answered with rows. Every other answer is the develop answer.
 *
 *  Coverage:
 *    Case 1: ELT whose index is a bind or a literal
 *    Case 2: ELT whose index the row gives, over a bind and a session variable of other collations
 *    Case 3: ELT branches whose collations do not merge
 *    Case 4: CONCAT over collations that do not merge, with and without a row
 *    Case 5: ELT with more than three string branches
 *    Case 6: CASE, IF and DECODE whose branches the compiler unifies
 *    Case 7: an index the row gives over branches of one collation
 *    Case 8: CASE, IF and DECODE over a bind and a session variable of another collation
 */
--+ holdcas on;
drop table if exists dbc_t;
create table dbc_t (a int);
insert into dbc_t values (1), (2), (3), (4);

-- Case 1 [A]. ELT whose index is a bind or a literal - the gate picks the branch once, as develop did.
evaluate 'Case 1: ELT with a bind or literal index';
set names iso88591 collate iso88591_en_ci;
prepare dbc_a from 'select elt(?, ?, ?) v, collation(elt(?, ?, ?)) c';
execute dbc_a using 2, '1', 2, 2, '1', 2;
execute dbc_a using 1, '1', 2, 1, '1', 2;
execute dbc_a using NULL, '1', 2, NULL, '1', 2;
execute dbc_a using 0, '1', 2, 0, '1', 2;
execute dbc_a using 3, '1', 2, 3, '1', 2;
deallocate prepare dbc_a;
prepare dbc_a2 from 'select elt(2, ?, ?) v, collation(elt(2, ?, ?)) c';
execute dbc_a2 using '1', 2, '1', 2;
deallocate prepare dbc_a2;

-- Case 2 [B]. ELT whose index the row gives, over a utf8_en_ci bind and a utf8_bin session variable. The branch
-- collations merge into utf8_en_ci for the statement, so every row, a sort, a GROUP BY and a DISTINCT use it.
evaluate 'Case 2: ELT with a row index over other collations';
set names utf8 collate utf8_en_ci;
set @dbc_bin = _utf8'B' collate utf8_bin;
prepare dbc_b1 from 'select a, elt(2 - a % 2, ?, @dbc_bin) v, collation(elt(2 - a % 2, ?, @dbc_bin)) c from dbc_t order by a';
execute dbc_b1 using 'a', 'a';
deallocate prepare dbc_b1;
prepare dbc_b2 from 'select v, collation(v) c from (select elt(2 - a % 2, ?, @dbc_bin) v from dbc_t order by a) d order by v, c';
execute dbc_b2 using 'a';
deallocate prepare dbc_b2;
prepare dbc_b3 from 'select v, collation(v) c from (select elt(1 + a % 2, ?, @dbc_bin) v from dbc_t order by a) d order by v, c';
execute dbc_b3 using 'a';
deallocate prepare dbc_b3;
prepare dbc_b4 from 'select v, count(*) n from (select elt(2 - a % 2, ?, @dbc_bin) v from dbc_t) d group by v order by v';
execute dbc_b4 using 'b';
deallocate prepare dbc_b4;
prepare dbc_b5 from 'select distinct elt(1 + a % 2, ?, @dbc_bin) v from dbc_t order by 1';
execute dbc_b5 using 'b';
deallocate prepare dbc_b5;

-- A number branch, which the row turns into a string, takes the merged collation too.
prepare dbc_b7 from 'select a, elt(2 - a % 2, ?, ?) v, collation(elt(2 - a % 2, ?, ?)) c from dbc_t order by a';
execute dbc_b7 using 'a', 2, 'a', 2;
deallocate prepare dbc_b7;

-- Case 3 [B']. The branches do not merge (utf8_en_ci against utf8_en_cs) - -1150 before any row.
evaluate 'Case 3: ELT branches that do not merge';
set @dbc_cs = _utf8'B' collate utf8_en_cs;
prepare dbc_b6 from 'select elt(2 - a % 2, ?, @dbc_cs) v from dbc_t order by a';
execute dbc_b6 using 'a';
deallocate prepare dbc_b6;

-- Case 4 [C]. CONCAT over collations that do not merge gives no value, so the row raises the error and no row
-- raises none, as develop did.
evaluate 'Case 4: CONCAT over collations that do not merge';
prepare dbc_c from 'select concat(?, @dbc_cs) v from dbc_t where a = ?';
execute dbc_c using 'a', 1;
execute dbc_c using 'a', 99;
deallocate prepare dbc_c;

-- Case 5 [D]. ELT with four string branches, the index from the row and from a bind.
evaluate 'Case 5: ELT with more than three branches';
prepare dbc_d1 from 'select a, elt(a, ?, ?, ?, ?) v, collation(elt(a, ?, ?, ?, ?)) c from dbc_t order by a';
execute dbc_d1 using 'p', 'q', 'r', 's', 'p', 'q', 'r', 's';
deallocate prepare dbc_d1;
prepare dbc_d2 from 'select elt(?, ?, ?, ?, ?) v, collation(elt(?, ?, ?, ?, ?)) c';
execute dbc_d2 using 4, 'p', 'q', 'r', 's', 4, 'p', 'q', 'r', 's';
deallocate prepare dbc_d2;

-- Case 6 [E]. CASE, IF and DECODE whose branches the compiler unifies.
evaluate 'Case 6: CASE, IF and DECODE unified by the compiler';
set names iso88591 collate iso88591_en_ci;
prepare dbc_e from 'select a, case when a = 1 then ? else ? end v, collation(if(a = 1, ?, ?)) c, collation(decode(a, 1, ?, ?)) d from dbc_t order by a';
execute dbc_e using '1', 2, '1', 2, '1', 2;
deallocate prepare dbc_e;

-- Case 7 [F]. An index the row gives over branches of one collation.
evaluate 'Case 7: a row index over branches of one collation';
prepare dbc_f from 'select a, elt(a, ?, ?) v, collation(elt(a, ?, ?)) c from dbc_t order by a';
execute dbc_f using 'p', 'q', 'p', 'q';
deallocate prepare dbc_f;

-- Case 8 [G]. CASE, IF and DECODE over a bind and a session variable of another collation - the compiler unifies
-- these too.
evaluate 'Case 8: CASE, IF and DECODE over other collations';
set names utf8 collate utf8_en_ci;
prepare dbc_g1 from 'select a, case when a % 2 = 1 then ? else @dbc_bin end v, collation(case when a % 2 = 1 then ? else @dbc_bin end) c, collation(if(a % 2 = 1, ?, @dbc_bin)) i, collation(decode(a % 2, 1, ?, @dbc_bin)) d from dbc_t order by a';
execute dbc_g1 using 'a', 'a', 'a', 'a';
deallocate prepare dbc_g1;
prepare dbc_g2 from 'select v, collation(v) c from (select case when a % 2 = 1 then ? else @dbc_bin end v from dbc_t order by a) d order by v, c';
execute dbc_g2 using 'a';
deallocate prepare dbc_g2;
prepare dbc_g3 from 'select a, case when a % 2 = 1 then ? else @dbc_cs end v, collation(case when a % 2 = 1 then ? else @dbc_cs end) c from dbc_t order by a';
execute dbc_g3 using 'a', 'a';
deallocate prepare dbc_g3;

set names utf8;
drop table dbc_t;
deallocate variable @dbc_bin, @dbc_cs;
--+ holdcas off;
