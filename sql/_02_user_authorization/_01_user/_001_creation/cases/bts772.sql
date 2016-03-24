--+ holdcas on;
--access unauthorized class delivered unsutable error message

call login('dba','') on class db_user;
create class foo ( i int, j int);
insert into foo values(1, 1);
create index i_foo_i on foo(i);

call login('public', '') on class db_user;

select * from foo where i = 1 using index i_foo_i(+);
select * from foo where i = 1 using index foo.i_foo_i(+);
select * from foo f where i = 1 using index f.i_foo_i(+);

call login('dba','') on class db_user;
drop foo;

call login('dba','') on class db_user;
create class foo ( i int, j int);
insert into foo values(1, 1);
create reverse index rdx on foo(i);

call login('public', '') on class db_user;

select * from foo where i = 1 using index rdx(+);
select * from foo where i = 1 using index foo.rdx(+);
select * from foo f where i = 1 using index f.rdx(+);

call login('dba','') on class db_user;
drop foo;

call login('dba','') on class db_user;
create class foo ( i int primary key, j int);
insert into foo values(1, 1);

call login('public', '') on class db_user;

select * from foo where i = 1 using index pk_foo_i(+);
select * from foo where i = 1 using index foo.pk_foo_i(+);
select * from foo f where i = 1 using index f.pk_foo_i(+);

call login('dba','') on class db_user;
drop foo;
--+ holdcas off;
