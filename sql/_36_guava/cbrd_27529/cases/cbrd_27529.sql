/**
 *  This test case verifies CBRD-27529 : evaluate the R_EQ lookups of a list subquery filter
 *  (IN, NOT IN, = SOME, <> ALL) through a hash set over the list.
 *  The hash set answers from the first lookup of one execution of the subquery on; a list too large for memory is read.
 *  1. three-valued logic: a list with no NULL, with a NULL, with only NULL, with no row
 *  2. type pairs: INT, BIGINT, NUMERIC of other scales, DOUBLE with -0.0, CHAR and VARCHAR, a case-insensitive
 *     collation, DATE and DATETIME
 *  3. NUMERIC values an expression makes
 *  4. a list that holds the same values many times
 *  5. a value no conversion reads
 *  6. trace: HASH_LOOKUP with its method (memory, hybrid) when the hash answers, for one outer row as well,
 *     none for a list too large for memory, a correlated subquery, and max_hash_list_scan_size 0
 *     NO_HASH_LOOKUP in a subquery: none for the term of that subquery only, in a view as well
 *  7. strings a collation compares equal: a space and a NUL in a byte collation, the same and an EUC space in
 *     euckr_bin, binary, utf8_ko_cs, utf8_tr_cs and utf8_gen_ci, a character with no weight in an expanding collation
 *  8. long strings stored compressed, negative NUMERIC values of other scales
 */

set @i = 0;

-- PREPARE TEST
drop table if exists ta, tb;
create table ta (id int, ca int, cb bigint, cc numeric(10,2), cd double, ce char(10), cf varchar(20),
                 cg varchar(20) collate utf8_en_ci, ch varchar(20), ci datetime, cj date);
create table tb (k varchar(10), ca int, cb bigint, cc numeric(12,3), cd double, ce char(10), cf varchar(20),
                 cg varchar(20) collate utf8_en_ci, cgb varchar(20) collate utf8_bin, ch varchar(20), ci datetime,
                 cj date);

insert into ta values (1, 1, 1, 1.00, 0.0, 'a', 'a', 'A', '1', datetime'2026-01-01 00:00:00', date'2026-01-01');
insert into ta values (2, 2, 2, 2.50, 2.5, 'b ', 'b', 'b', '2', datetime'2026-01-02 00:00:00', date'2026-01-02');
insert into ta values (3, null, null, null, null, null, null, null, null, null, null);
insert into ta values (4, 4, 4, 4.00, 4.0, 'd', 'd ', 'D', '4', datetime'2026-01-04 12:00:00', date'2026-01-04');
insert into ta values (5, 5, 5, 5.10, 5.1, 'e', 'e', 'e', '5', datetime'2026-01-05 00:00:00', date'2026-01-05');

-- k = 'plain': no NULL
insert into tb values ('plain', 1, 1, 1.000, -0.0, 'a', 'a', 'a', 'a', '1', datetime'2026-01-01 00:00:00', date'2026-01-01');
insert into tb values ('plain', 4, 4, 4.000, 4.0, 'd', 'd', 'd', 'd', '4', datetime'2026-01-04 00:00:00', date'2026-01-04');
insert into tb values ('plain', 6, 6, 6.000, 6.0, 'f', 'f', 'f', 'f', '6', datetime'2026-01-06 00:00:00', date'2026-01-06');
insert into tb values ('plain', 5, 5, 5.100, 5.1, 'e ', 'e ', 'E', 'E', '5', datetime'2026-01-05 00:00:00', date'2026-01-05');
-- k = 'null': a NULL among the values
insert into tb values ('null', 1, 1, 1.000, 0.0, 'a', 'a', 'a', 'a', '1', datetime'2026-01-01 00:00:00', date'2026-01-01');
insert into tb values ('null', null, null, null, null, null, null, null, null, null, null, null);
-- k = 'allnull': only NULL
insert into tb values ('allnull', null, null, null, null, null, null, null, null, null, null, null);
-- k = 'bad': a string no number reads
insert into tb values ('bad', 1, 1, 1, 1, 'a', 'a', 'a', 'a', '1', null, null);
insert into tb values ('bad', 2, 2, 2, 2, 'b', 'b', 'b', 'b', 'x', null, null);

update statistics on ta, tb with fullscan;

-- START TEST
do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. three-valued logic');

select id from ta where ta.ca in (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca not in (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca = some (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca <> all (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca in (select tb.ca from tb where tb.k = 'null') order by 1;
select id from ta where ta.ca not in (select tb.ca from tb where tb.k = 'null') order by 1;
select id from ta where ta.ca <> all (select tb.ca from tb where tb.k = 'null') order by 1;
select id from ta where ta.ca not in (select tb.ca from tb where tb.k = 'allnull') order by 1;
select id from ta where ta.ca not in (select tb.ca from tb where tb.k = 'none') order by 1;
select id, case when ta.ca not in (select tb.ca from tb where tb.k = 'null') then 'T'
                when not (ta.ca not in (select tb.ca from tb where tb.k = 'null')) then 'F' else 'U' end
  from ta order by 1;
select id, case when ta.ca in (select tb.ca from tb where tb.k = 'plain') then 'T'
                when not (ta.ca in (select tb.ca from tb where tb.k = 'plain')) then 'F' else 'U' end
  from ta order by 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. type pairs');

select id from ta where ta.ca not in (select tb.cb from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cb not in (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca not in (select tb.cc from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cc not in (select tb.ca from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cc not in (select tb.cc from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cd not in (select tb.cd from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ca not in (select tb.cd from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ce not in (select tb.ce from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ce not in (select tb.cf from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cf not in (select tb.ce from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cf not in (select tb.cf from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cg not in (select tb.cg from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cf not in (select tb.cg from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cg not in (select tb.cf from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cg not in (select tb.cgb from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cj not in (select tb.ci from tb where tb.k = 'plain') order by 1;
select id from ta where ta.ci not in (select tb.cj from tb where tb.k = 'plain') order by 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. NUMERIC values an expression makes');

select id from ta where ta.cc not in (select tb.cc / 3 * 3 from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cc * 1.00 not in (select tb.cc + 0.000 from tb where tb.k = 'plain') order by 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. a list that holds the same values many times');

select id from ta where ta.ca not in (select tb.ca from tb where tb.k = 'plain'
                                      union all select tb.ca from tb where tb.k = 'plain'
                                      union all select tb.ca from tb where tb.k = 'null') order by 1;
select id from ta where ta.cf not in (select tb.cf from tb where tb.k = 'plain'
                                      union all select tb.cf from tb where tb.k = 'plain') order by 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. a value no conversion reads');

select id from ta where ta.ca not in (select tb.ch from tb where tb.k = 'bad') order by 1;
select id from ta where ta.ch not in (select tb.ca from tb where tb.k = 'plain') order by 1;

set trace on;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: the hash answers');

select /*+ recompile */ count (*) from ta where ta.ca not in (select tb.ca from tb where tb.k = 'plain');
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: one outer row');

select /*+ recompile */ count (*) from ta where ta.id = 1 and ta.ca not in (select tb.ca from tb where tb.k = 'plain');
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: a correlated subquery');

select /*+ recompile */ count (*) from ta
where ta.ca not in (select tb.ca from tb where tb.k = 'plain' and tb.cb <> ta.id);
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: tuple positions in memory (max_hash_list_scan_size below a page)');

set system parameters 'max_hash_list_scan_size=1k';
select /*+ recompile */ count (*) from ta where ta.ca not in (select tb.ca from tb where tb.k = 'null');
show trace;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: none for a list too large for memory (max_hash_list_scan_size below the positions): the lookups read the list');

set system parameters 'max_hash_list_scan_size=100';
select /*+ recompile */ count (*) from ta where ta.ca not in (select tb.ca from tb where tb.k = 'null');
show trace;
select id from ta where ta.cg not in (select tb.cgb from tb where tb.k = 'plain') order by 1;
select id from ta where ta.cc * 1.00 not in (select tb.cc + 0.000 from tb where tb.k = 'plain') order by 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: max_hash_list_scan_size 0 turns the hash off');

set system parameters 'max_hash_list_scan_size=0';
select /*+ recompile */ count (*) from ta where ta.ca not in (select tb.ca from tb where tb.k = 'null');
show trace;
set system parameters 'max_hash_list_scan_size=default';

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. trace: NO_HASH_LOOKUP in a subquery turns the hash off for the term of that subquery');

select /*+ recompile */ count (*) from ta
where ta.ca not in (select /*+ NO_HASH_LOOKUP */ tb.ca from tb where tb.k = 'plain');
show trace;
-- the other term's subquery has no hint: its lookups use the hash
select /*+ recompile */ count (*) from ta
where ta.ca not in (select /*+ NO_HASH_LOOKUP */ tb.ca from tb where tb.k = 'plain')
  and ta.cb not in (select tb.cb from tb where tb.k = 'plain');
show trace;
-- in the outer query the hint does not reach the subquery
select /*+ recompile NO_HASH_LOOKUP */ count (*) from ta where ta.ca not in (select tb.ca from tb where tb.k = 'plain');
show trace;
-- IN, left a filter by OR rather than made a join
select /*+ recompile */ count (*) from ta
where ta.ca in (select /*+ NO_HASH_LOOKUP */ tb.ca from tb where tb.k = 'plain') or ta.id < 0;
show trace;
-- a view keeps the hint
create view v27529 as select ta.id from ta where ta.ca not in (select /*+ NO_HASH_LOOKUP */ tb.ca from tb where tb.k = 'plain');
show create view v27529;
select /*+ recompile */ count (*) from v27529;
show trace;
drop view v27529;

set trace off;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. strings a byte collation compares equal: a space and a NUL, trailing NULs');

create table tc (id int, ca varchar(10), cb varchar(10) collate utf8_en_ci);
create table td (ca varchar(10), cb varchar(10) collate utf8_en_ci);
insert into tc values (1, 'x', 'x'), (2, 'a b', 'A B'), (3, 'a', 'a'), (4, 'q', 'Q');
insert into td values ('a' || chr (0) || 'b', 'a' || chr (0) || 'b'), ('a' || chr (0), 'A' || chr (0));
select id from tc where tc.ca not in (select td.ca from td) order by 1;
select id from tc where tc.ca <> all (select td.ca from td) order by 1;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. strings the other built-in collations and a locale''s collation compare equal: a space, a NUL and an EUC space, trailing ones');

create table tv (id int, s varchar(10));
create table tw (s varchar(10));
insert into tv values (1, 'x'), (2, 'a b'), (3, 'a' || chr (0) || 'b'), (4, 'c'), (5, 'c '), (6, 'c' || chr (0)),
                      (7, '가 나'), (8, 'q');
insert into tw values ('a' || chr (41377 using euckr) || 'b'), ('c' || chr (41377 using euckr)),
                      ('가' || chr (0) || '나'), ('c' || chr (0) || chr (0)), ('Q');
set trace on;

create table tc (id int, ca varchar(10) collate euckr_bin, cb char(10) collate euckr_bin);
create table td (ca varchar(10) collate euckr_bin, cb char(10) collate euckr_bin);
insert into tc select id, s, s from tv;
insert into td select s, s from tw;
select /*+ recompile */ id from tc where tc.ca not in (select td.ca from td) order by 1;
show trace;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;

create table tc (id int, ca varchar(10) collate binary, cb char(10) collate binary);
create table td (ca varchar(10) collate binary, cb char(10) collate binary);
insert into tc select id, s, s from tv;
insert into td select s, s from tw;
select /*+ recompile */ id from tc where tc.ca not in (select td.ca from td) order by 1;
show trace;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;

create table tc (id int, ca varchar(10) collate utf8_ko_cs, cb char(10) collate utf8_ko_cs);
create table td (ca varchar(10) collate utf8_ko_cs, cb char(10) collate utf8_ko_cs);
insert into tc select id, s, s from tv;
insert into td select s, s from tw;
select /*+ recompile */ id from tc where tc.ca not in (select td.ca from td) order by 1;
show trace;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;

create table tc (id int, ca varchar(10) collate utf8_tr_cs, cb char(10) collate utf8_tr_cs);
create table td (ca varchar(10) collate utf8_tr_cs, cb char(10) collate utf8_tr_cs);
insert into tc select id, s, s from tv;
insert into td select s, s from tw;
select /*+ recompile */ id from tc where tc.ca not in (select td.ca from td) order by 1;
show trace;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;

create table tc (id int, ca varchar(10) collate utf8_gen_ci, cb char(10) collate utf8_gen_ci);
create table td (ca varchar(10) collate utf8_gen_ci, cb char(10) collate utf8_gen_ci);
insert into tc select id, s, s from tv;
insert into td select s, s from tw;
select /*+ recompile */ id from tc where tc.ca not in (select td.ca from td) order by 1;
show trace;
select id from tc where tc.cb not in (select td.cb from td) order by 1;
drop table tc, td;
set trace off;
drop table tv, tw;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. a character an expanding collation gives no weight (U+00AD)');

create table tc (id int, ca varchar(10) collate utf8_de_exp_ai_ci);
create table td (ca varchar(10) collate utf8_de_exp_ai_ci);
insert into tc values (1, 'x'), (2, 'café'), (3, 'ca­fe'), (4, 'q');
insert into td values ('cafe');
select id from tc where tc.ca not in (select td.ca from td) order by 1;
select id from tc where tc.ca <> all (select td.ca from td) order by 1;
drop table tc, td;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. long compressed strings in the list');

create table tc (id int, ca varchar(2000));
create table td (ca varchar(2000));
insert into td select repeat ('x', 1000) || rownum from db_class a, db_class b limit 50;
insert into tc select rownum, repeat ('x', 1000) || (rownum * 2) from db_class a, db_class b limit 20;
select count (*) from tc where tc.ca not in (select td.ca from td);
drop table tc, td;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. negative NUMERIC values of other scales an expression makes');

create table tc (id int, n numeric(10,1));
create table td (m numeric(12,4));
insert into tc values (1, -1.0), (2, -2.5), (3, 1.0), (4, -10.0), (5, -0.5);
insert into td values (-1.0000), (-2.5000), (1.0000), (-10.0000), (-0.5000);
select id from tc where tc.n * 1.00 not in (select td.m * 1.0 from td) order by 1;
select id from tc where tc.n * 1.00 in (select td.m + 0.000 from td) order by 1;
drop table tc, td;

-- CLEAN UP
drop table ta, tb;
drop variable @i;
