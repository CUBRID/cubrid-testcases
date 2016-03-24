autocommit off;
create class foo (x int);
create index i_foo_x on foo(x);
insert into foo values (1);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
insert into foo select x + 1 from foo;    --    2
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 2 from foo;    --    4
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 4 from foo;    --    8
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 8 from foo;    --   16
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 16 from foo;   --   32
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 32 from foo;   --   64
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 64 from foo;   --  128
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 128 from foo;  --  256
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 256 from foo;  --  512
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 512 from foo;  -- 1024
select count(*) from foo where x between 0 and 2049;
insert into foo select x + 1024 from foo; -- 2048
select count(*) from foo where x between 0 and 2049;
select * from foo where x = 1;
select * from foo where x = 2048;
select * from foo where x = 2049;
select count(*) from foo where x < 100;
select count(*) from foo where x < 500;
select count(*) from foo where x < 1000;
select count(*) from foo where x < 1500;
select count(*) from foo where x < 2000;
select count(*) from foo where x < 2050;
select count(*) from foo where x > 0;
select count(*) from foo where x > 100;
select count(*) from foo where x > 500;
select count(*) from foo where x > 1000;
select count(*) from foo where x > 1500;
select count(*) from foo where x > 2000;
select count(*) from foo where x between 20 and 1540;
update foo set x = x + 3 where x > 0;
select count(*) from foo where x < 100;
select count(*) from foo where x < 500;
select count(*) from foo where x < 1000;
select count(*) from foo where x < 1500;
select count(*) from foo where x < 2000;
select count(*) from foo where x < 2050;
select count(*) from foo where x > 0;
select count(*) from foo where x > 100;
select count(*) from foo where x > 500;
select count(*) from foo where x > 1000;
select count(*) from foo where x > 1500;
select count(*) from foo where x > 2000;
select count(*) from foo where x between 20 and 1540;
select count(*) from foo where x < 3;
delete from foo where x < 100;
select count(*) from foo where x > 0;
delete from foo where x < 500;
select count(*) from foo where x > 0;
delete from foo where x < 1000;
select count(*) from foo where x > 0;
delete from foo where x < 1500;
select count(*) from foo where x > 0;
delete from foo where x < 2000;
select count(*) from foo where x > 0;
delete from foo where x < 2050;
select count(*) from foo where x > 0;
delete from foo where x = 2051;
select count(*) from foo where x > 0;
delete from foo where x = 2050;
select count(*) from foo where x > 0;
drop foo;
rollback;
