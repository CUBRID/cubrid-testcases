/**
 *  This test case verifies CBRD-28249: a page batch runs the range comparisons of a string column as leaves -- the
 *  bounds the rewrite adds to "col LIKE ?" (like_match_lower_bound / like_match_upper_bound, computed once per
 *  execution) and "col < 'x'", "col >= ?" and the other orders -- with the results and the errors of the row path.
 *
 *  Coverage:
 *    Case 1: col LIKE ? over a utf8_bin VARCHAR -- a prefix, a pattern without one, other case, the empty pattern,
 *            NULL, '_', a trailing space
 *    Case 2: the same over a utf8_en_ci VARCHAR, and over a CHAR column as a control the page batch does not run
 *    Case 3: literal orders over the three columns, the constant on either side, trailing spaces
 *    Case 4: host-variable orders, a NULL bound value
 *    Case 5: an ESCAPE the bounds reject: the error on a table with rows, none on an empty table, none where an
 *            earlier term is FALSE on every row, and a valid ESCAPE
 *    Case 6: the same handle again after the bounds failed: a valid ESCAPE, the failing one, other bounds -- each
 *            execution computes its own bounds -- and an ESCAPE the bounds reject where an earlier term lets some
 *            rows reach the LIKE (the error) or none
 */
drop table if exists tb, te;
create table tb (id int, v varchar(20) collate utf8_bin, e varchar(20) collate utf8_en_ci, c char(10));
insert into tb select level,
  case mod(level, 9) when 0 then 'ab' when 1 then 'ab ' when 2 then 'AB' when 3 then 'abc' when 4 then '' when 5 then null when 6 then 'b가나' when 7 then 'a_c' else 'xyz' end,
  case mod(level, 7) when 0 then 'ab' when 1 then 'AB ' when 2 then 'Ab' when 3 then 'abd' when 4 then null when 5 then 'aa' else 'zz' end,
  case mod(level, 5) when 0 then 'ab' when 1 then 'abc' when 2 then null when 3 then 'b' else '' end
  from dual connect by level <= 6000;
create table te (id int, v varchar(20) collate utf8_bin);
evaluate 'Case 1: col LIKE ? over a utf8_bin VARCHAR';
prepare q from 'select count(*), sum(id) from tb where v like ?';
execute q using 'ab%';
execute q using '%b%';
execute q using 'AB%';
execute q using '';
execute q using null;
execute q using 'a_c%';
execute q using 'ab ';
evaluate 'Case 2: col LIKE ? over a utf8_en_ci VARCHAR and a CHAR';
prepare q from 'select count(*), sum(id) from tb where e like ?';
execute q using 'ab%';
execute q using '%B%';
-- a control: the page batch does not run the LIKE of the CHAR column (its data filter is interpreted), so this
-- result is the row path's
prepare q from 'select count(*), sum(id) from tb where c like ?';
execute q using 'ab%';
execute q using '%b%';
evaluate 'Case 3: literal orders';
select count(*), sum(id) from tb where v >= 'ab';
select count(*), sum(id) from tb where v < 'ab ';
select count(*), sum(id) from tb where v > 'ab';
select count(*), sum(id) from tb where v <= '';
select count(*), sum(id) from tb where 'ab' < v;
select count(*), sum(id) from tb where 'abc' >= v;
select count(*), sum(id) from tb where e >= 'AB';
select count(*), sum(id) from tb where e < 'ab';
select count(*), sum(id) from tb where c >= 'ab';
select count(*), sum(id) from tb where c < 'b';
evaluate 'Case 4: host-variable orders';
prepare q from 'select count(*), sum(id) from tb where v > ? and v <= ?';
execute q using 'a', 'ab ';
execute q using null, 'ab';
prepare q from 'select count(*), sum(id) from tb where e > ?';
execute q using 'AB';
evaluate 'Case 5: an ESCAPE the bounds reject, and a valid one';
prepare q from 'select count(*), sum(id) from tb where v like ? escape ?';
execute q using 'ab%', 'xy';
prepare q2 from 'select count(*) from te where v like ? escape ?';
execute q2 using 'ab%', 'xy';
prepare q3 from 'select count(*) from tb where id < 0 and v like ? escape ?';
execute q3 using 'ab%', 'xy';
prepare q4 from 'select count(*), sum(id) from tb where v like ? escape ?';
execute q4 using 'a\_%', '\';
evaluate 'Case 6: the same handle after a failed execution, and the rows an earlier term lets through';
prepare q from 'select count(*), sum(id) from tb where v like ? escape ?';
execute q using 'ab%', 'xy';
execute q using 'a\_%', '\';
execute q using 'ab%', 'xy';
execute q using 'abc%', '\';
execute q using 'b%', '\';
prepare q3 from 'select count(*) from tb where id <= 10 and v like ? escape ?';
execute q3 using 'ab%', 'xy';
execute q3 using 'ab%', '\';
prepare q2 from 'select count(*) from tb where id > 6000 and v like ? escape ?';
execute q2 using 'ab%', 'xy';
deallocate prepare q;
deallocate prepare q2;
deallocate prepare q3;
deallocate prepare q4;
drop table tb, te;
