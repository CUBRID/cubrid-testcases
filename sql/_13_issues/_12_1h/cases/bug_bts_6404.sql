create table foo (a int, b varchar(3000), primary key(a, b)); 
insert into foo select rownum*2, 'aa' from db_class a, db_class b, db_class c limit 64000; 
insert into foo values(101, rpad('b', 2000, 'b')); 
select * from foo where a=101 order by b;
drop table foo;
