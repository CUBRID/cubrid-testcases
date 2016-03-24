autocommit off;
create class bas (x int);
create class bar (y int);
create vclass ffoo (a int, b set(float)) 
	as select x, set (select y from bar) from bas;
insert into bar values (1);
insert into bar values (2);
insert into bas values (10);
insert into bas values (11);
select * from ffoo;
rollback;
