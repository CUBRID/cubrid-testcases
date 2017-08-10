create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz, datetime_col1 datetimetz);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', datetimetz '1970-01-01 00:00:00.000', datetimetz '1970-01-01 00:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimetz '2008-01-12 08:08:08.999', datetimetz '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimetz '2008-03-12 08:08:08.999', datetimetz '2008-01-12 08:08:08.999');
insert into test_class(date_col) values (DATE '02/02/2009');

select datetime_col from test_class group by datetime_col  order by 1;
select datetime_col, count(*) from test_class group by datetime_col order by 1;
select * from test_class order by datetime_col ;
select * from test_class order by datetime_col desc ;
select * from test_class order by datetime_col asc;

drop class test_class;
