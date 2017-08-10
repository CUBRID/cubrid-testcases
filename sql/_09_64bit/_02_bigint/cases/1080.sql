--MULTISET, query
create class test_class (col_set MULTISET bigint);

insert into test_class(col_set) values ({-9223372036854775808, 9223372036854775807});
insert into test_class(col_set) values ({-100, 100});
insert into test_class(col_set) values ({0, -0});
insert into test_class(col_set) values ({NULL, NULL});
insert into test_class(col_set) values ({-9223372036854775808, 9223372036854775807, 9223372036854775807});
insert into test_class(col_set) values ({-100, 100, -100});
insert into test_class(col_set) values ({NULL, NULL, null});
insert into test_class(col_set) values ({-100, -10, 100, 10, 0});

select * from test_class order by 1;

select * from test_class where col_set = {-100, 100};
select * from test_class where col_set = {-100, 100, -100};
select * from test_class where col_set = {-100, -100, 100};
select * from test_class where col_set = {100};
select * from test_class where col_set = {NULL};
select * from test_class where col_set = {NULL, NULL};

drop class test_class;
