/**
 *  This test case verifies CBRD-28108: concatenating a FLOAT or DOUBLE cast to CHAR writes
 *  past the result buffer and can crash the server.
 *
 *  Before the fix, a FLOAT or DOUBLE cast to CHAR(n) had no pad spaces up to n, unlike a
 *  NUMERIC cast to CHAR(n). The concatenation of CHAR values allocated the bytes of the value
 *  but wrote it padded to n, so it wrote past the result buffer, returned a cut value, and
 *  crashed the server for a cast to CHAR(100). Other string functions read the value without
 *  its pad spaces. The fix pads the cast value to n and makes the concatenation allocate the
 *  missing pad bytes.
 *
 *  Each case runs one expression on the casts of the DOUBLE column ca and the NUMERIC
 *  column cc, and some cases also on the FLOAT column cb. The results must match.
 *
 *  Coverage:
 *    Case 1:  the || operator returns the cast value padded to n
 *    Case 2:  CONCAT and CONCAT_WS return the cast value padded to n
 *    Case 3:  RPAD, REPEAT and REVERSE read the pad spaces of the cast value
 *    Case 4:  REPLACE, INSERT and SUBSTR read the pad spaces of the cast value
 *    Case 5:  the cast value has n characters and n bytes
 *    Case 6:  a number as long as n gets no pad spaces
 *    Case 7:  a number longer than n fails with an overflow error
 *    Case 8:  a cast to VARCHAR gets no pad spaces
 *    Case 9:  the cast value stored in a CHAR column keeps its pad spaces
 *    Case 10: a cast to CHAR with the euckr charset pads with its two-byte space
 *    Case 11: the || operator on a cast to CHAR(100) returns 101 characters, with no crash
 */

drop table if exists ta, tb;

create table ta (id int, ca double, cb float, cc numeric(5,1));
insert into ta values (1, 1.5, 1.5, 1.5), (2, -1.5, -1.5, -1.5), (3, null, null, null);

evaluate 'Case 1: the || operator returns the cast value padded to n';
select
  id,
  cast(ca as char(10)) || '|',
  cast(cb as char(10)) || '|',
  cast(cc as char(10)) || '|'
from ta
order by id;

evaluate 'Case 2: CONCAT and CONCAT_WS return the cast value padded to n';
select
  id,
  concat(cast(ca as char(10)), '|'),
  concat_ws(',', cast(ca as char(10)), '|')
from ta
order by id;
select
  id,
  concat(cast(cb as char(10)), '|'),
  concat_ws(',', cast(cb as char(10)), '|')
from ta
order by id;
select
  id,
  concat(cast(cc as char(10)), '|'),
  concat_ws(',', cast(cc as char(10)), '|')
from ta
order by id;

evaluate 'Case 3: RPAD, REPEAT and REVERSE read the pad spaces of the cast value';
select
  id,
  rpad(cast(ca as char(10)), 12, '*'),
  repeat(cast(ca as char(10)), 2),
  reverse(cast(ca as char(10)))
from ta
order by id;
select
  id,
  rpad(cast(cc as char(10)), 12, '*'),
  repeat(cast(cc as char(10)), 2),
  reverse(cast(cc as char(10)))
from ta
order by id;

evaluate 'Case 4: REPLACE, INSERT and SUBSTR read the pad spaces of the cast value';
select
  id,
  replace(cast(ca as char(10)), '5', '7'),
  insert(cast(ca as char(10)), 2, 1, 'x'),
  substr(cast(ca as char(10)), 1, 5) || '|'
from ta
order by id;
select
  id,
  replace(cast(cc as char(10)), '5', '7'),
  insert(cast(cc as char(10)), 2, 1, 'x'),
  substr(cast(cc as char(10)), 1, 5) || '|'
from ta
order by id;

evaluate 'Case 5: the cast value has n characters and n bytes';
select
  id,
  char_length(cast(ca as char(10))),
  octet_length(cast(ca as char(10))),
  char_length(cast(cb as char(10))),
  octet_length(cast(cb as char(10))),
  char_length(cast(cc as char(10))),
  octet_length(cast(cc as char(10)))
from ta
order by id;

-- Cases 6 and 7 read only the row of 1.5, whose number has 3 characters
evaluate 'Case 6: a number as long as n gets no pad spaces';
select
  cast(ca as char(3)) || '|',
  cast(cb as char(3)) || '|',
  cast(cc as char(3)) || '|'
from ta
where id = 1;

evaluate 'Case 7: a number longer than n fails with an overflow error; result = error';
select cast(ca as char(2)) from ta where id = 1;
select cast(cb as char(2)) from ta where id = 1;
select cast(cc as char(2)) from ta where id = 1;

evaluate 'Case 8: a cast to VARCHAR gets no pad spaces';
select
  id,
  cast(ca as varchar(10)) || '|',
  cast(cb as varchar(10)) || '|',
  cast(cc as varchar(10)) || '|'
from ta
order by id;

evaluate 'Case 9: the cast value stored in a CHAR column keeps its pad spaces';
create table tb (id int, cd char(10), ce char(10));
insert into tb select id, cast(ca as char(10)), cast(cc as char(10)) from ta;
select id, cd || '|', octet_length(cd), ce || '|', octet_length(ce) from tb order by id;

-- a euckr space is two bytes long, so octet_length counts each pad space as two bytes
evaluate 'Case 10: a cast to CHAR with the euckr charset pads with its two-byte space';
select
  id,
  char_length(cast(ca as char(10) charset euckr)),
  octet_length(cast(ca as char(10) charset euckr)),
  char_length(cast(ca as char(10) charset euckr) || '|'),
  octet_length(cast(ca as char(10) charset euckr) || '|')
from ta
order by id;
select
  id,
  char_length(cast(cc as char(10) charset euckr)),
  octet_length(cast(cc as char(10) charset euckr)),
  char_length(cast(cc as char(10) charset euckr) || '|'),
  octet_length(cast(cc as char(10) charset euckr) || '|')
from ta
order by id;

-- before the fix, the server crashed from CHAR(24) in the CS mode and csql from CHAR(16) in the SA mode
-- this case uses CHAR(100), well past both sizes, and runs last because it crashes a build without the fix
evaluate 'Case 11: the || operator on a cast to CHAR(100) returns 101 characters, with no crash';
select
  id,
  char_length(cast(ca as char(100)) || '|'),
  char_length(cast(cb as char(100)) || '|'),
  char_length(cast(cc as char(100)) || '|')
from ta
order by id;

drop table ta, tb;
