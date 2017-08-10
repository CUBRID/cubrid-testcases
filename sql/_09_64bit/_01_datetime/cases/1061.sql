create class test_class (int_col int, datetime_col datetime default DATETIME '1990-01-02 23:59:59.999');

insert into test_class(int_col) values(1);

alter class test_class modify datetime_col datetime default DATETIME '1991-01-02 23:59:59.999';

insert into test_class(int_col) values(2);

select * from test_class order by 1;

drop class test_class;