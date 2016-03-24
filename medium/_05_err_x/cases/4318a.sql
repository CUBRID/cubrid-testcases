autocommit off;
create class parent ( estate int);
create class child as subclass of parent ( estate monetary )
inherit estate of parent;
rollback;
