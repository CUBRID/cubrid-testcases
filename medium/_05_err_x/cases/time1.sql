autocommit off;
 create class test_class (id int unique, data1 time);
 insert into test_class (id, data1) values (1, TIME '8:00:00 AM');
 insert into test_class (id, data1) values (2, TIME '20:00:00 AM');
 insert into test_class (id, data1) values (3, TIME '20:00:00 PM');
 select * from test_class;
rollback;
