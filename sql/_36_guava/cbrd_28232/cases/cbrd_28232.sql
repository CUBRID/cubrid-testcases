/*
 * CBRD-28232: REGEXP functions on multibyte strings.
 *
 * The position argument was checked against the byte size of the source, not
 * its character length. A position past the last character of a multibyte
 * string reached the engine: cppstd threw std::out_of_range and aborted the
 * server, and re2 REGEXP_REPLACE dropped the source.
 * re2 reported the empty matches of \B between the bytes of one UTF-8
 * character, which gave broken UTF-8 and wrong counts and positions.
 * REGEXP_INSTR passed the unconverted bytes of an EUC-KR source to the engine.
 *
 * A position past the end must give the same result as for an ASCII string
 * (0, the source unchanged, NULL), and every match must be on a character
 * boundary.
 * The engines define \b and \B words differently (re2 counts only ASCII
 * letters as word characters), so Case 3 checks re2 alone.
 *
 * Coverage:
 *   Case 1: a position past the last character, under cppstd
 *   Case 2: Case 1 repeated under re2
 *   Case 3: \B and \b on multibyte strings, under re2
 *   Case 4: REGEXP_INSTR on an EUC-KR column, under both engines
 *   Case 5: a CHAR column, whose padding counts as characters, under both engines
 */
drop table if exists t_28232, t_28232_a, t_28232_e, t_28232_c;
create table t_28232 (id int primary key, s varchar(100));
insert into t_28232 values (1, '가나다'), (2, 'a가'), (3, '😀a😀'), (4, '가 나a'), (5, 'ab cd');
create table t_28232_a (s varchar(20));
insert into t_28232_a values ('abc');
create table t_28232_e (s varchar(20) charset euckr);
insert into t_28232_e values ('가나다a');
create table t_28232_c (s char(5));
insert into t_28232_c values ('가나');

set system parameters 'regexp_engine=cppstd';

evaluate 'Case 1: a position past the last character, under cppstd';
select regexp_count(s, 'a', 5), regexp_instr(s, 'x*', 5), regexp_replace(s, 'x*', 'X', 5), regexp_substr(s, '.', 5)
  from t_28232 where id = 1;
select regexp_count(s, 'a', 9), regexp_instr(s, 'x*', 9), regexp_replace(s, 'x*', 'X', 9, 1), regexp_substr(s, '.', 9)
  from t_28232 where id = 1;
select regexp_count(s, 'x*', 4), regexp_instr(s, 'x*', 4), regexp_replace(s, 'x*', 'X', 4), regexp_substr(s, '.', 4)
  from t_28232 where id = 1;
select regexp_count(s, 'x*', 4), regexp_instr(s, 'x*', 4), regexp_replace(s, 'x*', 'X', 4), regexp_substr(s, '.', 4)
  from t_28232_a;
select regexp_count('가나다', 'a', 5), regexp_replace('가나다', '^', 'X', 4), regexp_instr('가나다', '다', 5),
  regexp_substr('가나다', '다', 5);
select regexp_count(s, 'x*', 3), regexp_instr(s, '다', 3, 1, 1), regexp_replace(s, 'x*', 'X', 3),
  regexp_substr(s, '.', 3) from t_28232 where id = 1;

set system parameters 'regexp_engine=re2';

evaluate 'Case 2: Case 1 repeated under re2';
select regexp_count(s, 'a', 5), regexp_instr(s, 'x*', 5), regexp_replace(s, 'x*', 'X', 5), regexp_substr(s, '.', 5)
  from t_28232 where id = 1;
select regexp_count(s, 'a', 9), regexp_instr(s, 'x*', 9), regexp_replace(s, 'x*', 'X', 9, 1), regexp_substr(s, '.', 9)
  from t_28232 where id = 1;
select regexp_count(s, 'x*', 4), regexp_instr(s, 'x*', 4), regexp_replace(s, 'x*', 'X', 4), regexp_substr(s, '.', 4)
  from t_28232 where id = 1;
select regexp_count(s, 'x*', 4), regexp_instr(s, 'x*', 4), regexp_replace(s, 'x*', 'X', 4), regexp_substr(s, '.', 4)
  from t_28232_a;
select regexp_count('가나다', 'a', 5), regexp_replace('가나다', '^', 'X', 4), regexp_instr('가나다', '다', 5),
  regexp_substr('가나다', '다', 5);
select regexp_count(s, 'x*', 3), regexp_instr(s, '다', 3, 1, 1), regexp_replace(s, 'x*', 'X', 3),
  regexp_substr(s, '.', 3) from t_28232 where id = 1;

evaluate 'Case 3: \B and \b on multibyte strings, under re2';
select id, hex(regexp_replace(s, '\B', '-')), regexp_count(s, '\B'), regexp_instr(s, '\B', 1, 1),
  regexp_instr(s, '\B', 1, 2), hex(regexp_substr(s, '\B', 1, 2)) from t_28232 where id > 1 order by id;
select id, hex(regexp_replace(s, '\b', '|')), regexp_count(s, '\b'), regexp_instr(s, '\b', 1, 2)
  from t_28232 where id > 1 order by id;
select id, regexp_replace(s, 'x*', '-'), regexp_count(s, 'x*') from t_28232 order by id;

evaluate 'Case 4: REGEXP_INSTR on an EUC-KR column, under both engines';
select regexp_instr(s, '나'), regexp_instr(s, 'a'), regexp_instr(s, '나', 1, 1, 1), regexp_instr(s, '다', 2),
  regexp_count(s, '나') from t_28232_e;
set system parameters 'regexp_engine=cppstd';
select regexp_instr(s, '나'), regexp_instr(s, 'a'), regexp_instr(s, '나', 1, 1, 1), regexp_instr(s, '다', 2),
  regexp_count(s, '나') from t_28232_e;

evaluate 'Case 5: a CHAR column, whose padding counts as characters, under both engines';
select regexp_count(s, ' ', 3), regexp_instr(s, ' ', 4), regexp_replace(s, ' ', '_', 5), regexp_count(s, ' ', 6)
  from t_28232_c;
set system parameters 'regexp_engine=re2';
select regexp_count(s, ' ', 3), regexp_instr(s, ' ', 4), regexp_replace(s, ' ', '_', 5), regexp_count(s, ' ', 6)
  from t_28232_c;

drop table t_28232, t_28232_a, t_28232_e, t_28232_c;
set system parameters 'regexp_engine=default';
