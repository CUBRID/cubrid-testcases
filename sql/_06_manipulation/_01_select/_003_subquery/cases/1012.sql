--Test update two columns using subquery 

create class test_class(a int, b int);
create class test_class1(a int, b int);
insert into test_class values(1, 1); 
insert into test_class1 values(1, 1);
insert into test_class1 values(2, 2);
insert into test_class1 values(null, null);

select  * from test_class order by 1;
update test_class set (a, b) = (select a , b from test_class1 where a is null);

drop test_class,test_class1;
