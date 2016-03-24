autocommit off;
create class bas (x set(string));
create class bar (x set(int));
insert into bar values ({1, 2});
insert into bar values ({2, 3});
insert into bas values ({'a', 'b'});
insert into bas values ({'b', 'c'});
select * from bar
union
select * from bas;
rollback;
