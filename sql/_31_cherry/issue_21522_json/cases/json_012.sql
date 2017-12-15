set system parameters 'ansi_quotes=no';
drop table if exists t1;
create table t1 (id int AUTO_INCREMENT , a json, b string);
insert into T1(b) values ('"ke""y1value1"');
insert into t1(a) select json_object(b,b) from t1;
insert into t1(a,b) values ('"single quotes test('')"','single quotes test(\')');
insert into t1(a,b) values ('"\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z"', 'a\bcdefghijklm\nopq\rs\tuvwxyz');

select * from t1 order by id;
set system parameters 'no_backslash_escapes=no';
insert into t1(a,b) select json_object(b,b),b from t1;
insert into t1(a,b) select json_array(b,b),b from t1 order by b desc;
select * from t1 order by id;
drop table if exists t1;


set system parameters 'ansi_quotes=yes';
set system parameters 'no_backslash_escapes=yes';
create table t1 (id int AUTO_INCREMENT , a json, b string);
insert into T1(b) values ('"ke""y1value1"');
insert into T1(a) values ('"ke""y1value1"');
insert into t1(a,b) select json_object(b,b),b from t1;
insert into t1(a,b) values ('"single quotes test('')"','single quotes test(\')');
insert into t1(a,b) values ('"\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z"', 'a\bcdefghijklm\nopq\rs\tuvwxyz');

select * from t1 order by id;

set system parameters 'ansi_quotes=no';
set system parameters 'no_backslash_escapes=no';
insert into T1(b) values ('"ke""y1value1"');
insert into T1(a) values ('"ke""y1value1"');
insert into t1(a,b) select json_object(b,b),b from t1;
insert into t1(a,b) select json_array(b,b),b from t1;
select * from t1 order by id;
select id, json_extract(a,'') from t1 order by id;
select id, json_extract(a,'/') from t1 order by id;
select id, json_extract(a,a) from t1 order by id;
select id, json_extract(a,b) from t1 order by id;
select id, json_extract(a, concat('/',b)) from t1 order by id;
select id, json_extract(a,'/"ke""y1value1"') from t1 order by id;
insert into t1(a,b) values ('"single quotes test('')"','single quotes test(\')');
insert into t1(a,b) values ('"\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z"', 'a\bcdefghijklm\nopq\rs\tuvwxyz');
select * from t1 order by id;
drop table if exists t1;

set system parameters 'ansi_quotes=default';
set system parameters 'no_backslash_escapes=default';
