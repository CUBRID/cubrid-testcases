--Test update using subquery with () for column 

create class test_class(a int, b int);
create class test_class1(a int, b int);
insert into test_class values(1, 1); 
insert into test_class1 values(1, 1);
insert into test_class1 values(2, 2);
insert into test_class1 values(null, null);

select  * from test_class order by 1;
update test_class set (a) = (select a from test_class1 where a = 4);

drop test_class,test_class1;
