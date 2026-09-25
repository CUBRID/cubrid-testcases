--+ holdcas on;
-- workspace#343 (map #312): the gate decides every string, a branch a row picks included
-- A, C, D, E, F, G keep develop's answers. B is decision D-343-01 (the user's choice "(다)", as MySQL does for ELT):
-- the branches' collations merge into one domain for the statement and every picked value takes it,
-- where develop labelled each row by its own branch and let the first row's branch type the sort
drop table if exists dbc_t;
create table dbc_t (a int);
insert into dbc_t values (1), (2), (3), (4);

-- A. ELT whose index is a bind or a literal: the gate picks the branch once (develop's answer)
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

-- B. ELT whose index the row gives, over a bind and a session variable of other collations (D-343-01)
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
-- a number branch, which the row turns into a string, takes the merged collation too
prepare dbc_b7 from 'select a, elt(2 - a % 2, ?, ?) v, collation(elt(2 - a % 2, ?, ?)) c from dbc_t order by a';
execute dbc_b7 using 'a', 2, 'a', 2;
deallocate prepare dbc_b7;

-- B'. the branches do not merge (utf8_en_ci against utf8_en_cs): rejected before any row (D-343-01)
set @dbc_cs = _utf8'B' collate utf8_en_cs;
prepare dbc_b6 from 'select elt(2 - a % 2, ?, @dbc_cs) v from dbc_t order by a';
execute dbc_b6 using 'a';
deallocate prepare dbc_b6;

-- C. collations that do not merge give no value: the row raises the error, and no row raises none (develop's timing)
prepare dbc_c from 'select concat(?, @dbc_cs) v from dbc_t where a = ?';
execute dbc_c using 'a', 1;
execute dbc_c using 'a', 99;
deallocate prepare dbc_c;

-- D. ELT with more string branches than three, index from the row and from a bind (develop's answer)
prepare dbc_d1 from 'select a, elt(a, ?, ?, ?, ?) v, collation(elt(a, ?, ?, ?, ?)) c from dbc_t order by a';
execute dbc_d1 using 'p', 'q', 'r', 's', 'p', 'q', 'r', 's';
deallocate prepare dbc_d1;
prepare dbc_d2 from 'select elt(?, ?, ?, ?, ?) v, collation(elt(?, ?, ?, ?, ?)) c';
execute dbc_d2 using 4, 'p', 'q', 'r', 's', 4, 'p', 'q', 'r', 's';
deallocate prepare dbc_d2;

-- E. CASE, IF and DECODE whose branches the compiler unifies keep develop's answers
set names iso88591 collate iso88591_en_ci;
prepare dbc_e from 'select a, case when a = 1 then ? else ? end v, collation(if(a = 1, ?, ?)) c, collation(decode(a, 1, ?, ?)) d from dbc_t order by a';
execute dbc_e using '1', 2, '1', 2, '1', 2;
deallocate prepare dbc_e;

-- F. a row-given index over branches of one collation is decided as before (develop's answer)
prepare dbc_f from 'select a, elt(a, ?, ?) v, collation(elt(a, ?, ?)) c from dbc_t order by a';
execute dbc_f using 'p', 'q', 'p', 'q';
deallocate prepare dbc_f;

-- G. CASE, IF and DECODE over a bind and a session variable of another collation: the compiler unifies them too
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
--+ holdcas off;
