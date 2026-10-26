/**
 *  This test case verifies CBRD-27510: collations decided at the gate keep develop's answers where the collation
 *  comes from outside the statement's own columns.
 *
 *  CBRD-27510 decides the collation of every string whose collation the compiler leaves open at the gate
 *  (qexec_resolve_domains, before the first row). This case probes an ENUM sibling, GROUP_CONCAT over NULL and over
 *  string binds, a statement prepared before SET NAMES or before ALTER ... COLLATE and executed after it, and
 *  multi-row VALUES whose binds have different character sets.
 *
 *  Every answer here is the develop answer. The GROUP_CONCAT over NULL binds in Case 2 is where develop's debug
 *  build stops on an assertion (qexec_end_one_iteration), and its release build answers NULL as CBRD-27510 does.
 *  COALESCE(enum_col, ?) keeps a develop defect in an ENUM sibling's collation that CBRD-27510 does not fix, so it
 *  stays out of this case.
 *
 *  Coverage:
 *    Case 1: an ENUM sibling of a literal or a column
 *    Case 2: GROUP_CONCAT over NULL and over string binds
 *    Case 3: SET NAMES after PREPARE
 *    Case 4: ALTER ... COLLATE after PREPARE
 *    Case 5: multi-row VALUES with binds of different character sets
 *    Case 6: the session's collation and character set
 */
--+ holdcas on;
drop table if exists dcg_te;
create table dcg_te (e enum('a','b') collate utf8_en_ci, s varchar(10) collate utf8_en_cs);
insert into dcg_te values ('a','x');

-- Case 1 [A]. An ENUM column of utf8_en_ci beside a literal or a utf8_en_cs column under COALESCE, NULLIF, CASE and
-- a plus.
evaluate 'Case 1: an ENUM sibling';
select coalesce(e, 'x'), collation(coalesce(e, 'x')), typeof(coalesce(e, 'x')) from dcg_te;
select nullif(e, 'x'), typeof(nullif(e, 'x')), collation(nullif(e, 'x')) from dcg_te;
select case when 1=1 then e else 'x' end, typeof(case when 1=1 then e else 'x' end), collation(case when 1=1 then e else 'x' end) from dcg_te;
select e + 'x', typeof(e + 'x'), collation(e + 'x') from dcg_te;
select coalesce(e, s), typeof(coalesce(e, s)), collation(coalesce(e, s)) from dcg_te;

-- Case 2 [B]. GROUP_CONCAT over NULL, over an empty column and over string binds.
evaluate 'Case 2: GROUP_CONCAT over NULL and string binds';
select group_concat(NULL), typeof(group_concat(NULL)), collation(group_concat(NULL)) from db_root;
select group_concat(s), collation(group_concat(s)) from dcg_te where 1=0;
prepare dcg_pb from 'select group_concat(?), collation(group_concat(?)) from db_root';
execute dcg_pb using NULL, NULL;
execute dcg_pb using 'a', 'a';
deallocate prepare dcg_pb;

-- Case 3 [C]. Statements prepared under one SET NAMES collation and executed under another.
evaluate 'Case 3: SET NAMES after PREPARE';
set names utf8 collate utf8_en_ci;
prepare dcg_pc1 from 'select ? = ?, collation(?)';
prepare dcg_pc2 from 'select ''a'' = ?, collation(''a''), collation(?)';
execute dcg_pc1 using 'a', 'A', 'a';
execute dcg_pc2 using 'A', 'A';
set names utf8 collate utf8_en_cs;
execute dcg_pc1 using 'a', 'A', 'a';
execute dcg_pc2 using 'A', 'A';
prepare dcg_pc3 from 'select ? = ?, collation(?)';
execute dcg_pc3 using 'a', 'A', 'a';
deallocate prepare dcg_pc1;
deallocate prepare dcg_pc2;
deallocate prepare dcg_pc3;
set names utf8;

-- Case 4 [D]. A statement prepared before ALTER ... COLLATE changes its column and executed after it.
evaluate 'Case 4: ALTER COLLATE after PREPARE';
drop table if exists dcg_tl;
create table dcg_tl (s varchar(10) collate utf8_en_cs);
insert into dcg_tl values ('Ab');
prepare dcg_pd from 'select s, collation(s) from dcg_tl where s like ?';
execute dcg_pd using 'a%';
alter table dcg_tl modify s varchar(10) collate utf8_en_ci;
execute dcg_pd using 'a%';
deallocate prepare dcg_pd;

-- Case 5 [E]. Multi-row VALUES whose binds have different character sets.
evaluate 'Case 5: multi-row VALUES with mixed character sets';
prepare dcg_pe from 'select * from (values (?), (?)) as v(c)';
execute dcg_pe using _utf8'a', _utf8'b';
execute dcg_pe using _utf8'a', _euckr'b';
deallocate prepare dcg_pe;

-- Case 6 [F]. The session's collation and character set after the case.
evaluate 'Case 6: the session collation and character set';
select collation('a'), charset('a');

drop table dcg_te;
drop table dcg_tl;
set names utf8;
--+ holdcas off;
