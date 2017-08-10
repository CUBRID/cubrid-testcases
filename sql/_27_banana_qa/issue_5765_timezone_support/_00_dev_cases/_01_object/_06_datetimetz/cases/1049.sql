create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz);

create index idx_datetime_col on test_class(datetime_col);

insert into test_class(datetime_col) values (datetimetz '0001-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1970-01-01 00:00:00.000');
insert into test_class(datetime_col) values (datetimetz '1990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (datetimetz '2990-01-02 23:59:59.999');

select a.*, b.* from test_class a, test_class b where a.datetime_col = b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a left join test_class b on a.datetime_col = b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a right join test_class b on a.datetime_col = b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a inner join test_class b on a.datetime_col = b.datetime_col order by 1,2,3,4,5,6,7,8;


select a.*, b.* from test_class a, test_class b where a.datetime_col > b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a left join test_class b on a.datetime_col > b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a right join test_class b on a.datetime_col > b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a inner join test_class b on a.datetime_col > b.datetime_col order by 1,2,3,4,5,6,7,8;

select a.*, b.* from test_class a, test_class b where a.datetime_col < b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a left join test_class b on a.datetime_col < b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a right join test_class b on a.datetime_col < b.datetime_col order by 1,2,3,4,5,6,7,8;
select a.*, b.* from test_class a inner join test_class b on a.datetime_col < b.datetime_col order by 1,2,3,4,5,6,7,8;

drop class test_class;