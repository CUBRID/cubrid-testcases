autocommit off;
create class ca_class class attribute (class_attr int) (int_attr int);
insert into ca_class (int_attr) values (111);
update class ca_class set class ca_class.class_attr = 111;
select class ca_class.class_attr from ca_class;

rollback;
