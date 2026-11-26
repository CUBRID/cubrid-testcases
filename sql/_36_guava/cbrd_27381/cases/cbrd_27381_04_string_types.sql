/**
 *  This test case verifies CBRD-27381: radix-sorted index builds of CHAR and VARCHAR under the byte-wise collations
 *
 *  A CHAR or VARCHAR takes the radix sorter under binary, iso88591_bin, utf8_bin, iso88591_en_cs,
 *  utf8_en_cs, iso88591_en_ci and utf8_en_ci, when its values stay under 255 bytes. Every collation but
 *  binary reads a space as zero, so binary is the one that keeps the spaces that pad a CHAR as they are.
 *  t_r and t_c hold the same rows. Every index of t_r is built with index_sort_method=radix and the same
 *  index of t_c with compare, both with index_build_buffer_size 64K so a build sorts several runs. Read
 *  in index order, each radix-built index must return the rows of its compare-built twin in the same
 *  order and find as many rows.
 *
 *  A query does not read an index whose first column is under a case-insensitive collation, so each
 *  en_ci column is read through a second index (z, column), where z is 0 in every row. Its index of
 *  its own is built for the build alone. The en_ci keys are compared upper-cased - keys the collation
 *  calls equal lie in OID order, which may differ between the two tables (debug builds check that
 *  order in every run).
 *
 *  Rows: g is the row generator of 6000 strings of signed numbers with a short suffix, in four shapes of
 *  1500 (scattered, ascending, descending, few distinct values - the order of the strings is not the
 *  order of the numbers), upper and lower case and trailing spaces mixed in, a NULL every 101st row.
 *  sp then adds the empty string, spaces, case pairs, the characters between Z and a, and Latin-1 and
 *  Korean letters (an ISO-8859-1 column stores a question mark for a Korean letter).
 *
 *  Coverage:
 *    Case 1:  VARCHAR under utf8_bin, utf8_en_cs, iso88591_bin, iso88591_en_cs and binary, CHAR under utf8_bin and
 *             binary, a VARCHAR(63) under utf8 (the widest that keeps under 255 bytes at 4 bytes a character)
 *             whose values share a 56-byte prefix, a VARCHAR(254) under binary and a descending CHAR index read
 *             back in the order of the compare-built twin
 *    Case 2:  VARCHAR and CHAR under utf8_en_ci, VARCHAR under iso88591_en_ci, a CHAR(1) and a descending en_ci
 *             VARCHAR, read through (z, column), read back in the order of the compare-built twin
 *    Case 3:  each radix-built index finds the rows whose key is not NULL, and every row through (z, column)
 *    Case 4:  the padding of a CHAR under utf8_bin makes a with and without trailing spaces one key
 */

drop table if exists g;
drop table if exists sp;
drop table if exists t_r;
drop table if exists t_c;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_r (id int, z int,
                  s1 varchar(30) collate utf8_bin, s2 varchar(30) collate utf8_en_cs, s3 varchar(30) collate utf8_en_ci,
                  s4 char(12) collate utf8_bin, s5 char(12) collate utf8_en_ci,
                  s6 varchar(30) collate iso88591_bin, s7 varchar(30) collate iso88591_en_ci,
                  s8 varchar(63) collate utf8_bin, s9 varchar(254) collate binary, s10 char(1) collate utf8_en_ci,
                  s11 char(12) collate binary, s12 varchar(30) collate iso88591_en_cs);

insert into t_r
  select n, 0, s, s2, s3, s, s2, s, s3,
         concat (lpad (s, 56, 'p'), repeat ('가', mod (n, 8))), concat (repeat ('q', mod (n, 200)), s), substr (s3, 1, 1), s, s2
  from (select n, s,
               case mod (n, 2) when 0 then upper (s) else s end as s2,
               case mod (n, 3) when 0 then upper (s) when 1 then s else concat (s, ' ') end as s3
        from (select n, concat (v, substr ('abcdefghij', 1, mod (n, 4))) as s from g) y) x
  order by n;

create table sp (id int, s varchar(10));
insert into sp values (6001, ''), (6002, ' '), (6003, '  '), (6004, 'a'), (6005, 'a '), (6006, 'a  '),
  (6007, 'A'), (6008, 'A '), (6009, 'b'), (6010, 'B'), (6011, 'Z'), (6012, 'z'), (6013, '['), (6014, '\'),
  (6015, ']'), (6016, '^'), (6017, '_'), (6018, '`'), (6019, '{'), (6020, '~'), (6021, 'ab'), (6022, 'aB'),
  (6023, 'Ab'), (6024, 'AB'), (6025, 'a_'), (6026, 'A`'), (6027, 'a`'), (6028, 'é'), (6029, 'É'), (6030, 'e'),
  (6031, 'ÿ'), (6032, '가'), (6033, '나'), (6034, '가 '), (6035, '0'), (6036, '-0'), (6037, '00');
insert into t_r select id, 0, s, s, s, s, s, s, s, s, s, substr (s, 1, 1), s, s from sp order by id;

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_r1 on t_r (s1);
create index i_r2 on t_r (s2);
create index i_r3 on t_r (s3);
create index i_r4 on t_r (s4);
create index i_r5 on t_r (s5);
create index i_r6 on t_r (s6);
create index i_r7 on t_r (s7);
create index i_r8 on t_r (s8);
create index i_r9 on t_r (s9);
create index i_r10 on t_r (s10);
create index i_r11 on t_r (s11);
create index i_r12 on t_r (s12);
create index i_r4d on t_r (s4 desc);
create index i_rz3 on t_r (z, s3);
create index i_rz5 on t_r (z, s5);
create index i_rz7 on t_r (z, s7);
create index i_rz10 on t_r (z, s10);
create index i_rz3d on t_r (z, s3 desc);
set system parameters 'index_sort_method=compare';
create index i_c1 on t_c (s1);
create index i_c2 on t_c (s2);
create index i_c4 on t_c (s4);
create index i_c6 on t_c (s6);
create index i_c8 on t_c (s8);
create index i_c9 on t_c (s9);
create index i_c11 on t_c (s11);
create index i_c12 on t_c (s12);
create index i_c4d on t_c (s4 desc);
create index i_cz3 on t_c (z, s3);
create index i_cz5 on t_c (z, s5);
create index i_cz7 on t_c (z, s7);
create index i_cz10 on t_c (z, s10);
create index i_cz3d on t_c (z, s3 desc);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

evaluate 'Case 1: each radix-built index of a case-sensitive collation reads back in the order of its compare-built twin; result = no rows differ';
-- each query prints the position and the key of the rows that differ from the compare-built twin
select 's1' as ix, x.* from ((select rownum, s1 from t_r where s1 >= '' using index i_r1)
  difference (select rownum, s1 from t_c where s1 >= '' using index i_c1)) x order by 2;
select 's2' as ix, x.* from ((select rownum, s2 from t_r where s2 >= '' using index i_r2)
  difference (select rownum, s2 from t_c where s2 >= '' using index i_c2)) x order by 2;
select 's4' as ix, x.* from ((select rownum, s4 from t_r where s4 >= '' using index i_r4)
  difference (select rownum, s4 from t_c where s4 >= '' using index i_c4)) x order by 2;
select 's6' as ix, x.* from ((select rownum, s6 from t_r where s6 >= '' using index i_r6)
  difference (select rownum, s6 from t_c where s6 >= '' using index i_c6)) x order by 2;
select 's8' as ix, x.* from ((select rownum, s8 from t_r where s8 >= '' using index i_r8)
  difference (select rownum, s8 from t_c where s8 >= '' using index i_c8)) x order by 2;
select 's9' as ix, x.* from ((select rownum, s9 from t_r where s9 >= '' using index i_r9)
  difference (select rownum, s9 from t_c where s9 >= '' using index i_c9)) x order by 2;
select 's11' as ix, x.* from ((select rownum, s11 from t_r where s11 >= '' using index i_r11)
  difference (select rownum, s11 from t_c where s11 >= '' using index i_c11)) x order by 2;
select 's12' as ix, x.* from ((select rownum, s12 from t_r where s12 >= '' using index i_r12)
  difference (select rownum, s12 from t_c where s12 >= '' using index i_c12)) x order by 2;
select 's4 desc' as ix, x.* from ((select rownum, s4 from t_r where s4 >= '' using index i_r4d)
  difference (select rownum, s4 from t_c where s4 >= '' using index i_c4d)) x order by 2;

evaluate 'Case 2: each radix-built en_ci index read through (z, column) reads back in the order of its compare-built twin; result = no rows differ';
select 's3' as ix, x.* from ((select rownum, upper (s3) from t_r where z >= 0 using index i_rz3)
  difference (select rownum, upper (s3) from t_c where z >= 0 using index i_cz3)) x order by 2;
select 's5' as ix, x.* from ((select rownum, upper (s5) from t_r where z >= 0 using index i_rz5)
  difference (select rownum, upper (s5) from t_c where z >= 0 using index i_cz5)) x order by 2;
select 's7' as ix, x.* from ((select rownum, upper (s7) from t_r where z >= 0 using index i_rz7)
  difference (select rownum, upper (s7) from t_c where z >= 0 using index i_cz7)) x order by 2;
select 's10' as ix, x.* from ((select rownum, upper (s10) from t_r where z >= 0 using index i_rz10)
  difference (select rownum, upper (s10) from t_c where z >= 0 using index i_cz10)) x order by 2;
select 's3 desc' as ix, x.* from ((select rownum, upper (s3) from t_r where z >= 0 using index i_rz3d)
  difference (select rownum, upper (s3) from t_c where z >= 0 using index i_cz3d)) x order by 2;

evaluate 'Case 3: each radix-built index finds the rows whose key is not NULL, and every row through (z, column)';
-- with no rows differing in Case 1 and Case 2, the same count means the radix-built index holds exactly the rows of its twin
select count(*) from t_r where s1 >= '' using index i_r1;
select count(*) from t_r where s2 >= '' using index i_r2;
select count(*) from t_r where s4 >= '' using index i_r4;
select count(*) from t_r where s6 >= '' using index i_r6;
select count(*) from t_r where s8 >= '' using index i_r8;
select count(*) from t_r where s9 >= '' using index i_r9;
select count(*) from t_r where s11 >= '' using index i_r11;
select count(*) from t_r where s12 >= '' using index i_r12;
select count(*) from t_r where s4 >= '' using index i_r4d;
select count(*) from t_r where z >= 0 using index i_rz3;
select count(*) from t_r where z >= 0 using index i_rz5;
select count(*) from t_r where z >= 0 using index i_rz7;
select count(*) from t_r where z >= 0 using index i_rz10;
select count(*) from t_r where z >= 0 using index i_rz3d;

evaluate 'Case 4: the padding of a CHAR under utf8_bin makes a with and without trailing spaces one key';
select count(*) from t_r where s4 = 'a' using index i_r4;

drop table g;
drop table sp;
drop table t_r;
drop table t_c;
