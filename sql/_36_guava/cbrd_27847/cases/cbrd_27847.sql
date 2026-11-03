/**
 *  This test case verifies CBRD-27847: INSERT and UPDATE store a string value that exactly matches the column
 *  without casting it
 *
 *  A VARCHAR, CHAR, BIT VARYING or BIT value of the type, precision, codeset and collation of the column, that fits
 *  the precision and does not own its buffer (a value read from a list file tuple or a record), is stored by sharing
 *  its buffer instead of being cast into a copy. Any other value is cast as before. The stored values and the errors
 *  do not change, so the cases print what each path stored, and Case 1 compares the shared path with a twin table
 *  that stores the same values through the cast.
 *
 *  Coverage:
 *    Case 1:  INSERT ... SELECT from columns of the same domain stores the values the cast stores in the twin table
 *    Case 2:  UPDATE from columns of the same domain, of a joined table, and from expressions
 *    Case 3:  MERGE, INSERT ... ON DUPLICATE KEY UPDATE and REPLACE
 *    Case 4:  values of another precision, collation, codeset or type, a shorter CHAR, a default value, literals
 *             and host variables are cast as before
 *    Case 5:  values longer than the column fail with Error:-427 and store nothing
 */


drop table if exists t27847_s, t27847_d, t27847_t;

create table t27847_s (
  id int primary key,
  v32 varchar(32) collate utf8_bin,
  v64 varchar(64) collate utf8_bin,
  vci varchar(32) collate utf8_en_ci,
  viso varchar(32) collate iso88591_bin,
  c10 char(10) collate utf8_bin,
  c5 char(5) collate utf8_bin,
  b16 bit(16),
  vb64 bit varying(64),
  vl varchar(2000) collate utf8_bin,
  vs string collate utf8_bin
);

-- 1: short, 2: full precision, 3: trailing spaces, 4: empty, 5: multibyte, 6: 32 multibyte characters (96 bytes), 7: NULL
insert into t27847_s values (1, 'abc', 'abc', 'Abc', 'abc', 'abc', 'abc', X'00FF', X'0123456789ABCDEF', 'abc', 'abc');
insert into t27847_s values (2, 'abcdefghijabcdefghijabcdefghij12', 'abcdefghijabcdefghijabcdefghij12', 'ABCDEFGHIJ',
  'abcdefghijabcdefghijabcdefghij12', 'abcdefghij', 'abcde', X'FFFF', X'FF', 'abcdefghijabcdefghijabcdefghij12',
  'abcdefghijabcdefghijabcdefghij12');
insert into t27847_s values (3, 'abc   ', 'abc   ', 'abc   ', 'abc   ', 'abc   ', 'a  ', X'0000', X'', 'abc   ', 'abc   ');
insert into t27847_s values (4, '', '', '', '', '', '', X'1234', X'00', '', '');
insert into t27847_s values (5, _utf8'한글 문자열', _utf8'한글 문자열', _utf8'한글', 'xyz', _utf8'한글', _utf8'한',
  X'ABCD', X'ABCDEF', _utf8'한글 문자열', _utf8'한글 문자열');
insert into t27847_s values (6, _utf8'가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라',
  _utf8'가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라', _utf8'가나다', 'xyz', _utf8'가나다라마바사아자차',
  _utf8'가나다라마', X'5A5A', X'5A5A5A5A5A5A5A5A', _utf8'가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라',
  _utf8'가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라');
insert into t27847_s values (7, null, null, null, null, null, null, null, null, null, null);
-- an iso88591 character that converts into two utf8 bytes
update t27847_s set viso = chr (233 using iso88591) || 'te' where id = 5;
-- strings of 255 bytes or more are compressed when they are written to a list file
update t27847_s set vl = repeat ('abcdefghij', 60) || id where id <= 2;
update t27847_s set vl = repeat (_utf8'가나다라마바사아자차', 50) || id where id = 5;

create table t27847_d (
  id int primary key,
  d32 varchar(32) collate utf8_bin,
  d10 char(10) collate utf8_bin,
  db16 bit(16),
  dvb64 bit varying(64),
  dl varchar(2000) collate utf8_bin,
  ds string collate utf8_bin,
  ddef varchar(32) collate utf8_bin default 'dflt'
);
create table t27847_t like t27847_d;


evaluate 'Case 1: INSERT ... SELECT from columns of the same domain stores the values the cast stores in the twin table';
insert into t27847_d (id, d32, d10, db16, dvb64, dl, ds) select id, v32, c10, b16, vb64, vl, vs from t27847_s;
select id, d32, char_length (d32), octet_length (d32), hex (d32), collation (d32), d10, octet_length (d10), hex (d10),
  db16, dvb64, char_length (dl), octet_length (dl), md5 (dl), ds, octet_length (ds), ddef
from t27847_d order by id;
-- the twin: the same values with another precision or type, so that each one is cast into the column
insert into t27847_t (id, d32, d10, db16, dvb64, dl, ds)
  select id, cast (v32 as varchar(64)), cast (c10 as varchar(10)), cast (b16 as bit varying(16)),
	 cast (vb64 as bit varying(128)), cast (vl as varchar(4000)), cast (vs as varchar(64))
  from t27847_s;
select count (*) from t27847_d d, t27847_t t
where d.id = t.id and nvl (hex (d.d32), 'N') = nvl (hex (t.d32), 'N')
  and nvl (octet_length (d.d10), -1) = nvl (octet_length (t.d10), -1) and nvl (hex (d.d10), 'N') = nvl (hex (t.d10), 'N')
  and nvl (hex (d.db16), 'N') = nvl (hex (t.db16), 'N') and nvl (hex (d.dvb64), 'N') = nvl (hex (t.dvb64), 'N')
  and nvl (md5 (d.dl), 'N') = nvl (md5 (t.dl), 'N') and nvl (hex (d.ds), 'N') = nvl (hex (t.ds), 'N');
select count (*) from t27847_d d, t27847_s s
where d.id = s.id and d.d32 = s.v32 and d.d10 = s.c10 and d.db16 = s.b16 and d.dvb64 = s.vb64 and d.dl = s.vl
  and d.ds = s.vs;


evaluate 'Case 2: UPDATE from columns of the same domain, of a joined table, and from expressions';
delete from t27847_d;
insert into t27847_d (id) select id from t27847_s;
update t27847_d d, t27847_s s set d.d32 = s.v32, d.d10 = s.c10, d.db16 = s.b16, d.dvb64 = s.vb64, d.dl = s.vl,
  d.ds = s.vs
where d.id = s.id;
select id, d32, octet_length (d32), hex (d32), d10, hex (d10), db16, dvb64, char_length (dl), md5 (dl), ds, ddef
from t27847_d order by id;
update t27847_d set d32 = ds, ds = d32 where id <> 6;
update t27847_d set d32 = upper (d32), d10 = lower (d10), dl = substr (dl, 1, 300), dvb64 = dvb64;
select id, d32, octet_length (d32), hex (d32), d10, hex (d10), dvb64, char_length (dl), md5 (dl), ds
from t27847_d order by id;


evaluate 'Case 3: MERGE, INSERT ... ON DUPLICATE KEY UPDATE and REPLACE';
delete from t27847_d where id > 3;
merge into t27847_d d using t27847_s s on (d.id = s.id)
  when matched then update set d.d32 = s.v32, d.d10 = s.c10, d.dvb64 = s.vb64
  when not matched then insert (id, d32, d10, dvb64, dl) values (s.id, s.v32, s.c10, s.vb64, s.vl);
select id, d32, octet_length (d32), d10, hex (d10), dvb64, char_length (dl), md5 (dl), ddef from t27847_d order by id;
insert into t27847_d (id, d32, d10) select id, v32, c10 from t27847_s on duplicate key update d32 = 'odku', d10 = 'x';
insert into t27847_d (id, d32, d10) select id + 10, v32, c10 from t27847_s on duplicate key update d32 = 'odku';
select id, d32, octet_length (d32), d10, hex (d10), ddef from t27847_d order by id;
replace into t27847_d (id, d32, d10, db16, dl) select id, v32, c10, b16, vl from t27847_s;
select id, d32, octet_length (d32), d10, hex (d10), db16, dvb64, char_length (dl), md5 (dl), ds, ddef
from t27847_d order by id;


evaluate 'Case 4: values of another precision, collation, codeset or type, defaults, literals and host variables are cast as before';
delete from t27847_d;
insert into t27847_d (id, d32, d10, dvb64, ds) select id, v64, c5, b16, v32 from t27847_s where id <> 6;
select id, d32, octet_length (d32), hex (d32), collation (d32), d10, octet_length (d10), hex (d10), dvb64, ds,
  collation (ds), ddef
from t27847_d order by id;
update t27847_d d, t27847_s s set d.d32 = s.vci where d.id = s.id;
select id, d32, hex (d32), collation (d32) from t27847_d order by id;
update t27847_d d, t27847_s s set d.d32 = s.viso where d.id = s.id;
select id, d32, hex (d32), charset (d32), collation (d32) from t27847_d order by id;
update t27847_d d, t27847_s s set d.d10 = s.v32 where d.id = s.id and char_length (s.v32) <= 10;
select id, d10, octet_length (d10), hex (d10) from t27847_d order by id;
update t27847_d d, t27847_s s set d.db16 = s.vb64 where d.id = s.id and bit_length (s.vb64) <= 16;
select id, db16, dvb64 from t27847_d order by id;
insert into t27847_d (id) values (100);
insert into t27847_d (id, d32) values (101, 'literal');
insert into t27847_d (id, d32, d10) values (102, _utf8'가나다', 'ab');
prepare q27847 from 'insert into t27847_d (id, d32, d10, dvb64) values (?, ?, ?, ?)';
execute q27847 using 103, 'bound', 'xy', X'0F0F';
execute q27847 using 104, 'abcdefghijabcdefghijabcdefghij12', 'abcdefghij', X'';
deallocate prepare q27847;
select id, d32, octet_length (d32), d10, hex (d10), dvb64, ddef, octet_length (ddef) from t27847_d where id >= 100
order by id;


evaluate 'Case 5: values longer than the column fail with Error:-427 and store nothing';
insert into t27847_d (id, d32) select 200, v64 || 'x' from t27847_s where id = 2;
insert into t27847_d (id, d32) select 201, vl from t27847_s where id = 1;
insert into t27847_d (id, d10) select 202, v32 from t27847_s where id = 2;
insert into t27847_d (id, db16) select 203, vb64 from t27847_s where id = 1;
update t27847_d d, t27847_s s set d.d32 = s.vs || s.vs where d.id = s.id and s.id = 2;
select count (*) from t27847_d where id >= 200;
select id, d32, octet_length (d32) from t27847_d where id = 2;


drop table t27847_s, t27847_d, t27847_t;
