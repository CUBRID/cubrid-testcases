autocommit off;
create class foo (x string);
create index i_foo_x on foo(x);
insert into foo values ('xx');
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select count(*) from foo where x = 'xx';
insert into foo select '1' + x + x from foo; -- 2 (max key = 5)
insert into foo select '2' + x + x from foo; -- 4 (max key = 11)
insert into foo select '3' + x + x from foo; -- 8 (max key = 23)
insert into foo select '4' + x + x from foo; -- 16 (max key = 47)
insert into foo select '5' + x + x from foo; -- 32 (max key = 95)
insert into foo select '6' + x + x from foo; -- 64 (max key = 191)
insert into foo select '7'+ x + x from foo; -- 128 (max key = 383)
insert into foo select '8'+ x + x from foo; -- 256 (max key = 767)
insert into foo select '9'+ x + x from foo; -- 512 (max key = 1535)
insert into foo select 'a'+ x from foo; -- 1024 (max key = 1536)
insert into foo select 'b'+ x from foo; -- 2048 (max key = 1537)
select count(*) from foo where x = '54321xxxx1xxxx21xxxx1xxxx321xxxx1xxxx21xxxx1xxxx4321xxxx1xxxx21xxxx1xxxx321xxxx1xxxx21xxxx1xxxx'; -- 1
select count(*) from foo where x = '12345xx'; -- 0
select count(*) from foo where x > ' '; -- 2048
select count(*) from foo where x < '3'; -- 3
update foo set x = '222' where x < '3';
select count(*) from foo where x = '222'; -- 3
select count(*) from foo where x > '3' and x < '5'; -- 12
delete from foo where x > '3' and x < '5'; 
select count(*) from foo where x > ' '; -- 2036
select count(*) from foo where x between '5' and '543'; -- 10
update foo set x = '6' where x between '5' and '543'; 
select count(*) from foo where x = '6';  -- 10;
select count(*) from foo where x between '5' and '5z'; -- 6
delete from foo where x between '5' and '5z';
select count(*) from foo where x between '5' and '5z'; -- 0
select count(*) from foo where x > ' '; -- 2030
select count(*) from foo where x > '6' and x < 'b'; -- 992
update foo set x = '222' where x > '6' and x < 'b'; -- 992(total of 995 '222's)
select count(*) from foo where x > '6'; -- 1025
delete from foo where x > '6'; -- 1025 
select count(*) from foo where x > ' '; -- 1005
select count(*) from foo where x <= '6'; -- 1005
delete from foo where x = '6'; -- 10
select count(*) from foo where x > ' '; -- 995
update foo set x = x + 'the end of the line' where x = '222';
select count(*) from foo where x = '222the end of the line'; -- 995
delete from foo where x = '222the end of the line'; -- 995
select count(*) from foo where x > ' '; -- 0
drop foo;
rollback;
