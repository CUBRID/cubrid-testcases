create class test_class (bigint_col bigint not null);

insert into test_class values(NULL);
insert into test_class values(100);

select * from test_class;

drop class test_class;