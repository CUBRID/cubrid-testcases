--set, Containment operators
create class test_class (col_set set bigint);

insert into test_class(col_set) values ({-9223372036854775808, 9223372036854775807});
insert into test_class(col_set) values ({-100, 100});
insert into test_class(col_set) values ({0, -0});
insert into test_class(col_set) values ({NULL, NULL});
insert into test_class(col_set) values ({-9223372036854775808, 9223372036854775807, 9223372036854775807});
insert into test_class(col_set) values ({-100, 100, -100});
insert into test_class(col_set) values ({NULL, NULL, null});
insert into test_class(col_set) values ({-100, -10, 100, 10, 0});

select * from test_class  order by 1;

select * from test_class where col_set seteq {-100, 100}  order by 1;
select * from test_class where col_set seteq {NULL, NULL} order by 1;

select * from test_class where col_set setneq {-100, 100} order by 1;
select * from test_class where col_set setneq {NULL, NULL} order by 1;

select * from test_class where col_set superset {100} order by 1;
select * from test_class where col_set superset {NULL} order by 1;

select * from test_class where col_set superseteq {-100, 100} order by 1;
select * from test_class where col_set superseteq {NULL} order by 1;

select * from test_class where col_set subset {-100, 100, 0} order by 1;
select * from test_class where col_set subset {NULL, 0} order by 1;

select * from test_class where col_set subseteq {-100, 100, 0} order by 1;
select * from test_class where col_set subseteq {NULL, 0} order by 1;

drop class test_class;
