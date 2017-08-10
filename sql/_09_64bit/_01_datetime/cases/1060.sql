create class test_class (int_col int, datetime_col datetime default DATETIME '1990-01-02 23:59:59.999' not null);

insert into test_class(int_col) values(NULL);
insert into test_class(int_col, datetime_col) values(1, NULL);
insert into test_class(int_col, datetime_col) values(2, DATETIME '2000-01-02 23:59:59.999');

select * from test_class order by 2;

drop class test_class;