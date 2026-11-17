autocommit off;
create class bar (y set(int));
create vclass foo (b sequence(int))
	as select y from bar;
insert into bar values ({1});
insert into bar values ({2});
select * from foo order by case when 1 in b then 1 else 2 end;
rollback;
