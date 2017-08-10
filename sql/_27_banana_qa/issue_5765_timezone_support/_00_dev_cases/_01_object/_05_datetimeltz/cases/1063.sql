create class test_class (int_col int, datetime_col datetimeltz, UNIQUE(datetime_col));

insert into test_class(int_col, datetime_col) values(1, datetimeltz '1994-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(2, datetimeltz '1992-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(3, datetimeltz '1993-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(4, datetimeltz '1992-01-02 23:59:59.999');

select * from test_class  order by 1;

drop class test_class;

