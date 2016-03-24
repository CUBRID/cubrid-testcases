
-- older select/using index test cases, with keylimit added

-- Tests  select statement which includes a number of 'or' keyword
create class xoo ( id int);
insert into xoo values(1);
insert into xoo values(2);
insert into xoo values(3);
insert into xoo values(4);
insert into xoo values(5);
insert into xoo values(6);
insert into xoo values(7);
insert into xoo values(8);
insert into xoo values(9);
insert into xoo values(10);
insert into xoo select id+10 from xoo;
create index i_xoo_id on xoo (id);

select  id from xoo
where
   (id between 1 and 5)
   or (id between 7 and 9)
   or (id > 4 and id < 10)
using index i_xoo_id(+) keylimit 3,5 order by 1;

select  id from xoo
where
   (id between 1 and 5)
   or (id > 4 and id < 10)
   or (id between 7 and 9)
using index i_xoo_id(+) keylimit 6,3 order by 1;

drop xoo;

-- Test using indexes in a select query
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
using index int_idx keylimit 0;

drop class foo;

--Test using indexes in a select query and force index to be scanned
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
using index int_idx(+) keylimit 0;

drop class foo;
