autocommit off;
create class bar (y int);
create vclass foo (b set(int)) 
	as select y from bar;
insert into bar values ({1});
insert into bar values ({2});
select * from foo;
rollback;
