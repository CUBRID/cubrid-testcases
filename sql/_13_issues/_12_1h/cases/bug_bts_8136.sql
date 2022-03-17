create table foo (a int, b string);
alter table foo partition by hash (a) partitions 4;
insert into foo values (1, 'foo');
prepare t1 from 'select ? as c, count(*) from foo where a = ?';
execute t1 using 'partitioning', 1;

drop foo;

create table foo (a int, b string);
insert into foo values (1, 'foo');

prepare t1 from 'select ? as c, count(*) from foo where a = ?'; execute t1 using 'OK', 1;
prepare t1 from 'select count(*), ? as c from foo where a = ?'; execute t1 using 'OK', 1;

drop foo;


create table foo (a int, b string);
insert into foo values (1, 'foo');

prepare t1 from 'select ?, ?+?, ?+? from foo where a = ?'; execute t1 using 10, 10, 1, 'O', 'K', 1;
prepare t1 from 'select ?, ?+?, ?+?, count(*) from foo where a = ?'; execute t1 using 10, 10, 1, 'O', 'K', 1;

drop prepare t1;
drop foo;
