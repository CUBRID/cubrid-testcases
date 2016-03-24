autocommit off;
create class test_class (int_attr integer NOT NULL);
insert into test_class values (1);
update test_class set int_attr = NULL;
insert into test_class values (NULL);
rollback;
