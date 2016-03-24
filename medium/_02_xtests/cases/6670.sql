autocommit off;
create class test_class (a set(integer), b set(float), c set(numeric(15,2)),
d integer, e float, f numeric(15,2));
insert into test_class values ({1}, {1.11}, {1111111111111.11},
                              1, 1.11, 1111111111111.11);
select cast(a as set(numeric)) from test_class;
select cast(b as set(integer)) from test_class;
select cast(c as set(float)) from test_class;
select cast(d as char(10)) from test_class;
select cast(e as char(15)) from test_class;
select cast(f as char(20)) from test_class;
select cast(a as set(char(10))) from test_class;
select cast(b as set(char(15))) from test_class;
select cast(c as set(char(20))) from test_class;
rollback;
