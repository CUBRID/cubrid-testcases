create class test_class (int_col int, datetime_col datetime, UNIQUE(datetime_col));

insert into test_class(int_col, datetime_col) values(1, DATETIME '1994-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(2, DATETIME '1992-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(3, DATETIME '1993-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(4, DATETIME '1992-01-02 23:59:59.999');

select * from test_class  order by 1;

drop class test_class;

