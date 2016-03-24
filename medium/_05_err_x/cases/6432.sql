autocommit off;
create class feaux( int_attr int);
insert into feaux (int_attr) values (1);
update class feaux set class_attr = 10;
select * from feaux;
select class_attr from class feaux;
select class class_attr.x from feaux x;
rollback;
