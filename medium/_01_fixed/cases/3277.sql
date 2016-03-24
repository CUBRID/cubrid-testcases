autocommit off;
create class foo( a int );
insert into foo values (1);
insert into foo values (2);
insert into foo values (3);
insert into foo values (4);
select * from foo;  
create view fff( b foo, c int )
as select x, y.a from foo x, foo y where x.a < y.a;
select * from fff;             
select b.a, c  from fff;
select b.a from fff;        
select c from fff;            
drop foo;
drop fff;
commit;
