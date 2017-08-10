create class test_class (int_col int, datetime_col datetimetz primary key);

insert into test_class(int_col) values(1);

alter class test_class modify datetime_col datetimetz default datetimetz '1991-01-02 23:59:59.999';

insert into test_class(int_col) values(2);
insert into test_class(int_col) values(2);
insert into test_class(int_col, datetime_col) values(5, datetimetz '1994-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(5, datetimetz '1992-01-02 23:59:59.999');
insert into test_class(int_col, datetime_col) values(5, datetimetz '1993-01-02 23:59:59.999');

select * from test_class  order by 1,2;

drop class test_class;

