create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz);

insert into test_class(datetime_col) values (datetimeltz '1-1-1 00:00:00.000');
insert into test_class(datetime_col) values (datetimeltz '0001-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimeltz '1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimeltz '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimeltz '2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimeltz '1970-01-01 00:00:00');
insert into test_class(datetime_col) values (datetimeltz '1990-01-02 23:59:59');
insert into test_class(datetime_col) values (datetimeltz '2990-01-02 23:59:59');
insert into test_class(datetime_col) values (datetimeltz '01/01/1970 00:00:00.000');
insert into test_class(datetime_col) values (datetimeltz '01/02/1990 23:59:59.999');
insert into test_class(datetime_col) values (datetimeltz '01/02/2990 23:59:59.999');
insert into test_class(datetime_col) values (datetimeltz '01/01/1970 00:00:00');
insert into test_class(datetime_col) values (datetimeltz '01/02/1990 23:59:59');
insert into test_class(datetime_col) values (datetimeltz '01/02/2990 23:59:59');

update test_class set datetime_col = datetimeltz '0002-01-02 00:00:00.000' where datetime_col = datetimeltz '0001-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1970-01-02 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-03 23:59:59.999' where datetime_col = datetimeltz '1990-01-02 23:59:59.999';
update test_class set datetime_col = datetimeltz '2990-01-03 23:59:59.999' where datetime_col = datetimeltz '2990-01-02 23:59:59.999';
update test_class set datetime_col = datetimeltz '01/03/1970 00:00:00.000' where datetime_col = datetimeltz '01/02/1970 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/04/1990 23:59:59.999' where datetime_col = datetimeltz '01/03/1990 23:59:59.999';
update test_class set datetime_col = datetimeltz '01/04/2990 23:59:59.999' where datetime_col = datetimeltz '01/03/2990 23:59:59.999';

select * from test_class order by 4;

drop class test_class;