create table foo (a int);
create index idx_foo_trunc on foo (TRUNC (a, -1));
SHOW INDEXES from foo;

insert into foo values (7), (15), (2200), (7001), (178), (4);

select /*+ recompile */ * from foo where TRUNC (a, -1) > 0;

drop foo;


create table foo (a char(5));
create index idx_foo_abs on foo (abs(-a));
update statistics on foo;
SHOW INDEXES from foo;

insert into foo values ('5'), ('11'), ('-1');

select /*+ recompile */ * from foo where abs(-a) > 0;

drop foo;

-- check 3 argument function
create table foo (str string, c1 char, c2 char);
insert into foo values ('abcabc','a','d');
insert into foo values ('xyzxyz','a','x');

create index idx_foo_translate on foo (translate(str,c1,c2));
update statistics on foo;
SHOW INDEXES from foo;

select /*+ recompile */ str original, translate(str,c1,c2) translated from foo where translate(str,c1,c2) in ('dbcdbc','smthsmth');

drop foo;


-- check function holder
create table foo (a string, b string, c string);
insert into foo values ('aaa','bbb','ccc');
insert into foo values ('bbb','ccc','aaa');
insert into foo values ('ccc','aaa','bbb');

create index idx_foo_elt on foo (ELT (3, a, b, c));
update statistics on foo;
SHOW INDEXES from foo;

select /*+ recompile */ * from foo where ELT(3, a, b, c) > 'aaa';

drop foo; 
