create table foo(a int primary key,b int);
insert into foo (a,b) values((select 1 from db_root), 1) on duplicate key update b=2;

drop foo;
