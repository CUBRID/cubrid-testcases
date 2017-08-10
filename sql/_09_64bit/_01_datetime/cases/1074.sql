--SEQUENCE, query
create class test_class (col_set SEQUENCE datetime);

insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'});
insert into test_class(col_set) values ({'1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111'});
insert into test_class(col_set) values ({NULL, NULL});
insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '9999-12-31 23:59:59.999'});
insert into test_class(col_set) values ({'1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111', '2001-01-01 01:01:01.111'});
insert into test_class(col_set) values ({NULL, NULL, null});
insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111', '3000-01-01 01:01:01.333'});

select * from test_class where col_set = {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'};
select * from test_class where col_set = {'11:59:59.999 PM 12/31/9999' , '12:00:00.000 AM 01/01/0001'};
select * from test_class where col_set = {'1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111', '2001-01-01 01:01:01.111'};
select * from test_class where col_set = {'1900-12-31 12:30:00.888'};
select * from test_class where col_set = {NULL};
select * from test_class where col_set = {NULL, NULL};

drop class test_class;