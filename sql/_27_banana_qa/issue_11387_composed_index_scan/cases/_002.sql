-- 0 rows selected.

drop table if exists foo;
create table foo ( a smallint, b varchar(10), c integer, d datetime );
insert into foo values ( 1, 'c', null, null );
insert into foo values ( 1, 'c', null, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 'c', -2147483648, null);
insert into foo values ( 1, 'c', -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 'c', 1, null );
insert into foo values ( 1, 'c', 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 'c', 2147483647, null );
insert into foo values ( 1, 'c', 2147483647, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 'c', null, null );
insert into foo values ( 2, 'c', null, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 'c', -2147483648, null );
insert into foo values ( 2, 'c', -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 'c', 1, null );
insert into foo values ( 2, 'c', 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 'c', 2147483647, null );
insert into foo values ( 2, 'c', 2147483647, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 'c', null, null );
insert into foo values ( 3, 'c', null, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 'c', -2147483648, null );
insert into foo values ( 3, 'c', -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 'c', 1, null );
insert into foo values ( 3, 'c', 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 'c', 2147483647, null );
insert into foo values ( 3, 'c', 2147483647, '2013-10-10 12:12:12.111' );


select * from foo where a = 1 and b < 'c' using index none;
select * from foo where a = 2 and b < 'c' using index none;
select * from foo where a = 3 and b < 'c' using index none;

create index idx1 on foo ( a , b , c );
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a , b , c desc);
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a , b desc, c );
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a , b desc, c desc);
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b , c );
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b , c desc);
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b desc, c );
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b desc, c desc);
select * from foo where a = 1 and b < 'c' using index idx1;
select * from foo where a = 2 and b < 'c' using index idx1;
select * from foo where a = 3 and b < 'c' using index idx1;


drop table foo;
