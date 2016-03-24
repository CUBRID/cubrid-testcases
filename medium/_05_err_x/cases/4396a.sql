autocommit off;
create class parent ( attr int);
create class child as subclass of parent
( attr double ) inherit attr of parent as aliased_attr;
rollback;
