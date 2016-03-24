autocommit off;
create class int_class_1000;
alter int_class_1000 add attribute int1 int;
insert into int_class_1000 values(1);
insert into int_class_1000 values(2);
insert into int_class_1000 values(3);
insert into int_class_1000 values(4);
insert into int_class_1000 values(5);
insert into int_class_1000 values(6);
insert into int_class_1000 values(7);
insert into int_class_1000 values(8);
insert into int_class_1000 values(9);
insert into int_class_1000 values(10);
insert into int_class_1000 select int1 + 10 from int_class_1000; -- 20
insert into int_class_1000 select int1 + 20 from int_class_1000; -- 40
insert into int_class_1000 select int1 + 40 from int_class_1000; -- 80
insert into int_class_1000 select int1 + 80 from int_class_1000; -- 160
insert into int_class_1000 select int1 + 160 from int_class_1000; -- 320
insert into int_class_1000 select int1 + 320 from int_class_1000; -- 640
insert into int_class_1000 select int1 + 640 from int_class_1000
			   where int1 <= 360; -- 1000
create class foo;
alter foo add attribute foo_int int unique;
insert into foo select int1 from int_class_1000;
savepoint p1;
update foo set foo_int = -1 * foo_int where foo_int <= 500;
select count(*), min(foo_int), max(foo_int), avg(foo_int) from foo 
where foo_int > -100000;
rollback work to p1;
select count(*), min(foo_int), max(foo_int), avg(foo_int) from foo 
where foo_int > -100000;
delete from foo where foo_int <= 500;
select count(*), min(foo_int), max(foo_int), avg(foo_int) from foo 
where foo_int > -100000;
rollback;
