autocommit off;
create class foo ( a int);
insert into foo values( 1 );
select a1 from foo, table(a) as t1(a1);
rollback;
