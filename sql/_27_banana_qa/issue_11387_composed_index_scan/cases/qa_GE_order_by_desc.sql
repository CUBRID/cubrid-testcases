-- 8 rows selected.

drop table if exists foo;
create table foo ( a integer, b integer, c integer, d datetime );
insert into foo values ( 1, 3, null, null );
insert into foo values ( 1, 3, null, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 3, -2147483648, null);
insert into foo values ( 1, 3, -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 3, 1, null );
insert into foo values ( 1, 3, 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 1, 3, 2147483647, null );
insert into foo values ( 1, 3, 2147483647, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 3, null, null );
insert into foo values ( 2, 3, null, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 3, -2147483648, null );
insert into foo values ( 2, 3, -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 3, 1, null );
insert into foo values ( 2, 3, 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 2, 3, 2147483647, null );
insert into foo values ( 2, 3, 2147483647, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 3, null, null );
insert into foo values ( 3, 3, null, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 3, -2147483648, null );
insert into foo values ( 3, 3, -2147483648, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 3, 1, null );
insert into foo values ( 3, 3, 1, '2013-10-10 12:12:12.111' );
insert into foo values ( 3, 3, 2147483647, null );
insert into foo values ( 3, 3, 2147483647, '2013-10-10 12:12:12.111' );


select * from foo where a = 1 and b >= 3 using index none order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index none order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index none order by b desc, c, d;

create index idx1 on foo ( a , b , c );
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a , b , c desc);
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a , b desc, c );
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a , b desc, c desc);
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b , c );
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b , c desc);
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b desc, c );
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;

drop index idx1 on foo;
create index idx1 on foo ( a desc, b desc, c desc);
select * from foo where a = 1 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 2 and b >= 3 using index idx1 order by b desc, c, d;
select * from foo where a = 3 and b >= 3 using index idx1 order by b desc, c, d;


drop table foo;
