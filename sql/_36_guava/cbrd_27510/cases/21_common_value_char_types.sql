/**
 *  This test case verifies CBRD-27510: a common-value node over a CHAR column and a bind keeps develop's CHAR answers.
 *
 *  NVL, NVL2, IFNULL, COALESCE, NULLIF, LEAST and GREATEST return one of their operands. Over a CHAR column and a bind,
 *  develop casts the operand NVL, NVL2, IFNULL and COALESCE return to the node's compiled CHAR domain, so the results
 *  group, sort and compare as CHAR, without regard to trailing spaces. CBRD-27510 resolves these nodes before the
 *  first row and gives them the same CHAR domain. NULLIF, LEAST and GREATEST compare a string bind the client cast to
 *  VARCHAR, so the column's trailing spaces count, as in develop. Every answer here is the develop answer.
 *
 *  Coverage:
 *    Case 1: NULLIF, LEAST and GREATEST of a bind and a CHAR column
 *    Case 2: NVL, IFNULL and COALESCE of a single-byte CHAR column and a bind in ORDER BY, GROUP BY and DISTINCT
 *    Case 3: NVL2 of a CHAR column, a VARCHAR column and a bind in ORDER BY, GROUP BY and DISTINCT
 */
--+ holdcas on;
drop table if exists cvc_t;
create table cvc_t (id int, c1 char(5) collate utf8_en_ci, c3 char(5) collate utf8_bin, v1 varchar(10) collate utf8_en_ci,
  c4 char(5) charset iso88591);
insert into cvc_t values (1, 'AB', 'AB', 'AB', 'AB');
insert into cvc_t values (2, 'AB', 'AB', 'AB   ', 'AB');
insert into cvc_t values (3, 'ab', 'ab', 'ab', 'ab');
insert into cvc_t values (4, 'ac', 'ac', 'ac', 'ac');
insert into cvc_t values (5, null, null, 'AB', null);

-- Case 1 [DEVELOP]. The bind string compared with a CHAR(5) column value
evaluate 'Case 1: NULLIF, LEAST and GREATEST of a bind and a CHAR column';
prepare q from 'select id, nullif(?, c3), least(?, c3), greatest(?, c3), ? = c3 from cvc_t order by 1';
execute q using 'AB', 'AB', 'AB', 'AB';
prepare q from 'select id, nullif(?, c1), least(?, c1), greatest(?, c1), ? = c1 from cvc_t order by 1';
execute q using 'AB', 'AB', 'AB', 'AB';

-- Case 2 [DEVELOP]. The bind fills the NULL row: its value groups and sorts with the column's values as CHAR
evaluate 'Case 2: NVL, IFNULL and COALESCE of a CHAR column and a bind';
prepare q from 'select id, nvl(c4, ?) from cvc_t order by 2, 1';
execute q using 'AB';
prepare q from 'select nvl(c4, ?) k, count(*) from cvc_t group by nvl(c4, ?) order by 1';
execute q using 'AB', 'AB';
prepare q from 'select distinct ifnull(c4, ?) from cvc_t order by 1';
execute q using 'AB';
prepare q from 'select id, coalesce(c4, ?) from cvc_t order by 2, 1';
execute q using 'AB';
prepare q from 'select id, dense_rank () over (order by nvl(c4, ?)) from cvc_t order by 1';
execute q using 'AB';

-- Case 3 [DEVELOP]. NVL2 returns the VARCHAR column or the bind, as CHAR
evaluate 'Case 3: NVL2 of a CHAR column, a VARCHAR column and a bind';
prepare q from 'select id, nvl2(c1, v1, ?) from cvc_t order by 2, 1';
execute q using 'AB';
prepare q from 'select nvl2(c1, v1, ?) k, count(*) from cvc_t group by nvl2(c1, v1, ?) order by 1';
execute q using 'AB', 'AB';
prepare q from 'select distinct nvl2(c1, v1, ?) from cvc_t order by 1';
execute q using 'AB';

deallocate prepare q;
drop table cvc_t;
--+ holdcas off;
