--+ holdcas on;
--characters with backslash with special meaning


set system parameters 'no_backslash_escapes=no';
set system parameters 'ansi_quotes=no';


select '\0';
select '\'';
select '\"';
select '\b';
select '\n';
select '\r';
select '\t';
select '\Z';
select '\\';
select '\%';
select '\_';
select '\\%';
select '\\_';


select '\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z';

select '\a\d\s\b';

select '\hello\rthere';


select length('abc\tdsdfasd');
select length('\abcbbb\b\dddd\\\r\s\ooop\neilwkfdlfa;asl;kdfj;alskd');
select '\abcbbb\b\dddd\\\r\s\ooop\neilwkfdlfa;asl;kdfj;alskd';




set system parameters 'no_backslash_escapes=yes';

select '\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z';
select '\'';
select '\"';
select '\b';
select '\n';
select '\r';
select '\t';
select '\Z';
select '\\';
select '\%';
select '\_';


select length('abc\tdsdfasd');
select length('\abcbbb\b\dddd\\\r\s\ooop\neilwkfdlfa;asl;kdfj;alskd');
select '\abcbbb\b\dddd\\\r\s\ooop\neilwkfdlfa;asl;kdfj;alskd';


set system parameters 'no_backslash_escapes=no';


commit;
--+ holdcas off;
