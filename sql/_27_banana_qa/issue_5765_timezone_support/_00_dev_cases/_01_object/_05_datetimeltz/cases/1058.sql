create class test_class (datetime_col datetimeltz not null);

insert into test_class values(NULL);
insert into test_class values(datetimeltz '1990-01-02 23:59:59.999');

select * from test_class;

drop class test_class;