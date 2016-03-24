--+ holdcas on;
set system parameters 'no_backslash_escapes=no';
set system parameters 'ansi_quotes=no';

select 'single quotes test('')', 'single quotes test(\')', if (strcmp('single quotes test('')', 'single quotes test(\')') = 0, 'ok', 'nok');
select "double quotes test("")", "double quotes test(\")", if (strcmp("double quotes test("")", "double quotes test(\")") = 0, 'ok', 'nok');
select "\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z", "a\bcdefghijklm\nopq\rs\tuvwxyz",
       if (strcmp("\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z", "a\bcdefghijklm\nopq\rs\tuvwxyz") = 0, 'ok', 'nok');

select '\\', length('\\'), if (length('\\') = 1, 'ok', 'nok');
select '""', length('""'), if (length('""') = 2, 'ok', 'nok');
select "''", length("''"), if (length("''") = 2, 'ok', 'nok');

set system parameters 'ansi_quotes=yes';

select '\%', if (strcmp('\%', '\\%') = 0, 'ok', 'nok');
select '\_', if (strcmp('\_', '\\_') = 0, 'ok', 'nok');


create table t1 (a varchar(200));
insert into t1 values ('aaabbb'), ('aaa%');
select if ((select a from t1 where a like 'aaa\%' escape '\\') = 'aaa%', 'ok', 'nok');
drop table t1;


create table t1 (a varchar(200));
insert into t1 values ('aaab'), ('aaa_');
select if ((select a from t1 where a like 'aaa\_' escape '\\') = 'aaa_', 'ok', 'nok');
drop table t1;
set system parameters 'no_backslash_escapes=yes';
commit;
--+ holdcas off;
