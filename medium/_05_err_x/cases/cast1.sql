autocommit off;
create class foo_son as subclass of foo;
insert into foo_son values (123) into :p1;
create class bar (x foo_son);
insert into bar values (:p1);
select cast(x as foo), x.a from bar;
rollback;
