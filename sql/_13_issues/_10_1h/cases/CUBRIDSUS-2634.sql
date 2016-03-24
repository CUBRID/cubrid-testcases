create table foo(i int);
insert into foo values(1),(2),(3),(4);
select * from foo where (i!=1) XOR (i=3) order by i;
drop foo;