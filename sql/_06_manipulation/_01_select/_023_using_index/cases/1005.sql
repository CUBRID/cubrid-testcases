--Test using mutli-index in a query
create class foo (i integer,s string,j integer,t string,x string );
create unique index foo_udx on foo (i, s, j, t);
create index int_idx on foo (i, j);
insert into foo values(101, 'abcdi', 100001, 'axyze', 'anhn');
insert into foo values(102, 'abcde', 100002, 'bxyzd', 'bnhn');
insert into foo values(103, 'abcdf', 100003, 'cxyzc', 'nhn');
insert into foo values(104, 'abcdg', 100004, 'dxyzb', 'nhn');
insert into foo values(105, 'abcdh', 100005, 'exyza', 'nhn');
select * from foo 
where i = 101 and j = 100001;

select * from foo 
where i = 101 and j = 100001 
using index int_idx, foo_udx;

drop class foo;


