create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz);

insert into test_class(datetime_col) values ('01/02/10999 23:59:59');

insert into test_class(datetime_col) values (datetimetz '0-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '2008-00-00 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-13-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-41 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-01 30:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-01 00:90:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-01 00:00:60.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-01 00:00:60.1000');
insert into test_class(datetime_col) values (datetimetz '13/01/1990 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '01/41/1990 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '01/01/1990 30:00:00.000');
insert into test_class(datetime_col) values (datetimetz '01/01/1990 00:90:00.000');
insert into test_class(datetime_col) values (datetimetz '01/01/1990 00:00:60.000');
insert into test_class(datetime_col) values (datetimetz '01/01/1990 00:00:60.1000');
insert into test_class(datetime_col) values (datetimetz 'nhn cubrid db');

select * from test_class;

drop class test_class;