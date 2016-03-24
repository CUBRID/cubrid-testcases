create table foo ( a integer, b varchar(10), c datetime ) reuse_oid;

insert into foo values ( 1, 'AAA',sys_datetime);
insert into foo values ( 2, 'AAA',sys_datetime);
insert into foo values ( 3, 'AAA',sys_datetime);
insert into foo values ( 4, 'AAA',sys_datetime);
insert into foo values ( 5, 'AAA',sys_datetime);


select a from foo where a in ( select a from foo where b = 'AAA' order by b, c limit 0, 10 );

select a from foo where a in ( select a from foo where b = 'AAA' limit 0, 10 ) order by 1;

select b from foo where a in ( select a from foo where b = 'AAA' order by a limit 0, 3 );

select a from foo where b in ( select b from foo where a < 4 order by b limit 0, 10) order by 1;

drop table foo;

