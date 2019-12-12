create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz);

insert into test_class(datetime_col) values ('1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values ('1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values ('2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values ('1970-01-01 00:00:00');
insert into test_class(datetime_col) values ('1990-01-02 23:59:59');
insert into test_class(datetime_col) values ('2990-01-02 23:59:59');
insert into test_class(datetime_col) values ('01/01/1970 00:00:00.000');
insert into test_class(datetime_col) values ('01/02/1990 23:59:59.999');
insert into test_class(datetime_col) values ('01/02/2990 23:59:59.999');
insert into test_class(datetime_col) values ('01/01/1970 00:00:00');
insert into test_class(datetime_col) values ('01/02/1990 23:59:59');
insert into test_class(datetime_col) values ('01/02/2990 23:59:59');

select * from test_class order by 4;

drop class test_class;