autocommit off;
create class a (a1 object, a2 object);
create class b as subclass of a;
select a1, a2 from all a;
select * from all a;
rollback;
