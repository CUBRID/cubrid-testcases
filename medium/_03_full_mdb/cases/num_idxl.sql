autocommit off;
create class bar (x numeric(38,2));
insert into bar values (123.45);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select * from bar where x = 123.45;
insert into bar select 2*x from bar; -- 2
insert into bar select 4*x from bar; -- 4
insert into bar select 8*x from bar; -- 8
insert into bar select 16*x from bar; -- 16
insert into bar select 32*x from bar; -- 32
insert into bar select 64*x from bar; -- 64
insert into bar select 128*x from bar; -- 128
insert into bar select 256*x from bar; -- 256
insert into bar select 512*x from bar; -- 512
insert into bar select 1024*x from bar; -- 1024
insert into bar select 2048*x from bar; -- 2048
create index i_bar_x on bar(x);
select count(*) from bar where x > 0;
select * from bar where x < 100000;
delete from bar where x < 100000;
select count(*) from bar where x > 0;  -- 2015
select count(*) from bar where x < 10000000; -- 118
update bar set x = x / 2 where x < 10000000;
select count(*) from bar where x < 10000000 / 2; -- 118
select count(*) from bar where x < 10000000; -- 118
select count(*) from bar where x > 10000000 and x < 100000000000; -- 632
update bar set x = -123.45 where x > 10000000 and x < 100000000000; 
select count(*) from bar where x < 10000000; -- 118 + 632 = 750
select count(*) from bar where x > 10000000; -- 2048 - 750 - 33 = 1265
update bar set x = 456.78 where x > 10000000;
select count(*) from bar where x = 456.78; -- 1265
delete from bar where x = 456.78;
delete from bar where x > 0; -- 118
select count(*) from bar where x > -12345;
delete from bar where x = -123.45;
select count(*) from bar where x > -12345; -- 0
insert into bar values (123.45);
insert into bar values (456.78);
select * from bar where x between 123.44 and 546.79;
drop bar;

rollback;
