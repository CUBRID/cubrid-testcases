create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz)
partition by range ( datetime_col) (
partition p0 values less than (datetimetz '1900-01-01 00:00:00.000'),
partition p1 values less than (datetimetz '2000-01-01 00:00:00.000'),
partition p2 values less than MAXVALUE );

insert into test_class(datetime_col) values (datetimetz '0001-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1000-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1127-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1644-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1911-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1937-07-07 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2001-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2002-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2003-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2004-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2005-01-02 23:59:59.999');
insert into test_class(datetime_col) values (NULL);

select * from test_class order by datetime_col ;
select * from test_class__p__p0 order by datetime_col ;
select * from test_class__p__p1 order by datetime_col ;
select * from test_class__p__p2 order by datetime_col ;

select * from test_class__p__p1 where datetime_col = datetimetz '1000-01-01 00:00:00.000' order by 4;

drop class test_class;
