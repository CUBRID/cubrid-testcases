--Test update two columns using subquery with alias

create class test_class(a int, b int);
create class test_class1(a int, b int);
insert into test_class values(1, 1); 
insert into test_class1 values(1, 1);
insert into test_class1 values(2, 2);
insert into test_class1 values(null, null);

select  * from test_class order by 1;
update test_class set a =1, b=1;
update test_class x set (x.a, x.b) = (select y.a , y.b from test_class y where exists ( select z.a from test_class1 z));

drop test_class,test_class1;
