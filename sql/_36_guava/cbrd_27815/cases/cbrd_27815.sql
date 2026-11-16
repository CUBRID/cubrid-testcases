/*
 * CBRD-27815: ELT() whose first string argument has a weaker collation
 * coercibility than another string argument coerces that argument to the
 * common collation by wrapping it in a CAST. The CAST was linked after the
 * argument itself instead of after the index argument, so the argument and
 * the CAST pointed at each other: the query failed with "'elt' requires
 * arguments with compatible collations." and the client crashed while
 * walking the parse tree.
 * The first string argument gets a new CAST only when it is not shorter than
 * the other string arguments; a shorter one is already cast by the length
 * unification of ELT.
 */

drop table if exists t_27815;

create table t_27815 (id int, a varchar(20) collate utf8_bin, b varchar(20) collate utf8_en_ci, d varchar(30) collate utf8_bin);
insert into t_27815 values (1, 'Abc', 'abc', 'Abc'), (2, 'Xyz', 'xyz', 'Xyz');

-- the first string argument is coerced to utf8_en_ci: no error
-- same length as the other string argument
select id, elt (1, a, b) r, collation (elt (1, a, b)) coll from t_27815 order by id;
-- longer than the other string argument
select id, elt (1, d, b) r, collation (elt (1, d, b)) coll from t_27815 order by id;

drop table t_27815;
