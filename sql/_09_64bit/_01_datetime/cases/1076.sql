--MULTISET, Containment operators
create class test_class (col_set MULTISET datetime);

insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'});
insert into test_class(col_set) values ({'1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111'});
insert into test_class(col_set) values ({NULL, NULL});
insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '9999-12-31 23:59:59.999'});
insert into test_class(col_set) values ({'1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111', '2001-01-01 01:01:01.111'});
insert into test_class(col_set) values ({NULL, NULL, null});
insert into test_class(col_set) values ({'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '1900-12-31 12:30:00.888', '2000-01-01 01:01:01.111', '3000-01-01 01:01:01.333'});

select * from test_class order by 1;

select * from test_class where col_set seteq {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'} order by 1;
select * from test_class where col_set seteq {NULL, NULL} order by 1;

select * from test_class where col_set setneq {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'} order by 1;
select * from test_class where col_set setneq {NULL, NULL} order by 1;

select * from test_class where col_set superset {'9999-12-31 23:59:59.999'} order by 1;
select * from test_class where col_set superset {NULL} order by 1;

select * from test_class where col_set superseteq {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000'} order by 1;
select * from test_class where col_set superseteq {NULL} order by 1;

select * from test_class where col_set subset {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '1900-12-31 12:30:00.888'} order by 1;
select * from test_class where col_set subset {NULL, '2000-01-01 01:01:01.111'} order by 1;

select * from test_class where col_set subseteq {'9999-12-31 23:59:59.999', '0001-01-01 00:00:00.000', '1900-12-31 12:30:00.888'} order by 1;
select * from test_class where col_set subseteq {NULL, '2000-01-01 01:01:01.111'} order by 1;

drop class test_class;
