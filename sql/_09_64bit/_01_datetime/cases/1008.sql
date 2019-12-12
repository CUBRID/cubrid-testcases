create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime);

insert into test_class(datetime_col) values (SYS_DATETIME);
insert into test_class(datetime_col) values (SYSDATETIME);
insert into test_class(datetime_col) values (CURRENT_DATETIME);
insert into test_class(datetime_col) values (DATETIME '1090-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2990-01-02 23:59:59.999');

update test_class set datetime_col = SYS_DATETIME where datetime_col = DATETIME '1090-01-02 23:59:59.999';
update test_class set datetime_col = SYSDATETIME where datetime_col = DATETIME '1990-01-02 23:59:59.999';
update test_class set datetime_col = CURRENT_DATETIME where datetime_col = DATETIME '2990-01-02 23:59:59.999';

drop class test_class;