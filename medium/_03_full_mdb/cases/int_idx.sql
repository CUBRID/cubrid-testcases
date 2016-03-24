autocommit off;
create class foo (x int);
create index i_foo_x on foo(x);
insert into foo values (1);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select * from foo where x = 1;
insert into foo values (2);
select * from foo where x = 2;
select * from foo where x = 3;
select * from foo where x between 0 and 4;
select * from foo where x between 4 and 0;
delete from foo where x = 2;
select * from foo where x = 2;
select * from foo where x = 1;
select * from foo where x between 0 and 4;
insert into foo values(2);
select * from foo where x = 2;
select * from foo where x between 0 and 4;
insert into foo select * from foo where x = 1;  --    2
insert into foo select * from foo where x = 1;  --    4
insert into foo select * from foo where x = 1;  --    8
insert into foo select * from foo where x = 1;  --   16
insert into foo select * from foo where x = 1;  --   32
insert into foo select * from foo where x = 1;  --   64
insert into foo select * from foo where x = 1;  --  128
select count(*) from foo where x = 1;
insert into foo select * from foo where x = 1;  --  256
select count(*) from foo where x = 1;	
insert into foo select * from foo where x = 1;  --  512
select count(*) from foo where x = 1;	
insert into foo select * from foo where x = 1;  -- 1024
select count(*) from foo where x = 1;	
insert into foo select * from foo where x = 1;  -- 2048
select count(*) from foo where x = 1;	
update foo set x = x + 3 where x = 1;
select count(*) from foo where x = 4;
delete from foo where x = 4;
select * from foo where x between 0 and 4;
drop foo;
rollback;
