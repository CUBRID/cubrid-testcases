autocommit off;
create class foo1 (a int unique);
create class foo2 as subclass of foo1;
alter class foo2 add a int;            -- Shadows inherited attribute
select * from db_class where class_name in ('foo1', 'foo2');
rollback;
