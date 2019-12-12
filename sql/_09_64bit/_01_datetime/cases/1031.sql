create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime, datetime_col1 datetime);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', DATETIME '1970-01-01 12:00:00.000', DATETIME '1970-01-01 12:00:00.000');

select CURRENT_DATETIME - CURRENT_DATETIME from test_class;
select CURRENT_DATETIME - CURRENT_DATETIME , CURRENT_DATETIME - 3600000 - CURRENT_DATETIME from test_class;

select datetime_col - datetime_col from test_class;
select datetime_col, datetime_col - 3600000 from test_class;
select datetime_col - datetime_col1 from test_class;

select datetime '02/14/2009 12:00:00'-datetime '02/13/2009 12:00:00' from test_class;

select datetime_col - (CURRENT_DATETIME - CURRENT_DATETIME)  from test_class;
select datetime_col - CURRENT_DATETIME + CURRENT_DATETIME  from test_class;
select datetime_col - datetime_col + datetime_col  from test_class;

drop class test_class;