create class test_class (int_col int, datetime_col datetimeltz default datetimeltz '1990-01-02 23:59:59.999');

insert into test_class(int_col) values(NULL);
insert into test_class(int_col, datetime_col) values(1, datetimeltz '2000-01-02 23:59:59.999');

select * from test_class order by 1;

drop class test_class;