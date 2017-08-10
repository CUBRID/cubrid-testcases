create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz);

insert into test_class(datetime_col) values (datetimetz '1-1-1 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '0001-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '1970-01-01 00:00:00');
insert into test_class(datetime_col) values (datetimetz '1990-01-02 23:59:59');
insert into test_class(datetime_col) values (datetimetz '2990-01-02 23:59:59');
insert into test_class(datetime_col) values (datetimetz '01/01/1970 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '01/02/1990 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '01/02/2990 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '01/01/1970 00:00:00');
insert into test_class(datetime_col) values (datetimetz '01/02/1990 23:59:59');
insert into test_class(datetime_col) values (datetimetz '01/02/2990 23:59:59');

delete from test_class where datetime_col = datetimetz '1990-01-02 23:59:59.999';
delete from test_class where datetime_col > datetimetz '1990-01-02 23:59:59.999';
delete from test_class where datetime_col >= datetimetz '1990-01-02 23:59:59.999';
delete from test_class where datetime_col < datetimetz '1970-01-01 00:00:00.000';
delete from test_class where datetime_col <= datetimetz '1970-01-01 00:00:00.000';

drop class test_class;