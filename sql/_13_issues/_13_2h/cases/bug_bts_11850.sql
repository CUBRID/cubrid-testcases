create table foo (i int, ts timestamp);
create table bar (i int, ts timestamp);

insert into foo values (1, timestamp'2013-7-18 16:34:56');

prepare stmt from 'insert into bar select * from foo where i = ?';
execute stmt using 1;

prepare stmt from 'insert into bar(i) select ts from foo where i = ?';
execute stmt using 1;

prepare stmt from 'insert into bar select * from foo where i = ?';
prepare stmt from 'insert into aoo select * from foo where i = ?';
execute stmt using 1;

prepare stmt from 'insert into bar select * from foo where i = ?';
prepare stmt from 'insert ihnto aoo select * from foo where i = ?';
execute stmt using 1;


select count(*) from bar;

deallocate prepare stmt;

drop table if exists foo, bar;
