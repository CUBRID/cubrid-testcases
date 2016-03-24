autocommit off;
create class parent ( estate int);
create class child as subclass of parent ( estate monetary );
alter child inherit estate of parent;
rollback;
