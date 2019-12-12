create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime)
partition by hash (datetime_col)
partitions 4
;

insert into test_class(datetime_col) values (DATETIME '0001-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1000-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1127-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1644-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1911-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1937-07-07 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values (DATETIME '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2001-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2002-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2003-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2004-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATETIME '2005-01-02 23:59:59.999');
insert into test_class(datetime_col) values (NULL);

select * from test_class order by 4;
select * from test_class__p__p0 order by 4;
select * from test_class__p__p1 order by 4;
select * from test_class__p__p2 order by 4;
select * from test_class__p__p3 order by 4;

select * from test_class__p__p3 where datetime_col is NULL order by 4;

drop class test_class;