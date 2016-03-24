--Test using index in update statement
create class foo (
i integer,s string, j integer,t string,x string );
insert into foo values(1,'a',2,'b','c');
insert into foo values(2,'x',7,'y','z');
insert into foo values(3,'c',8,'d','e');
insert into foo values(4,'f',9,'l','m');
insert into foo values(5,'',null,'',''); 

create unique index foo_udx on foo (i, s, j, t);
create index int_idx on foo (i, j);

update foo set i = 2008 
where  j is null
using index int_idx;

drop class foo;