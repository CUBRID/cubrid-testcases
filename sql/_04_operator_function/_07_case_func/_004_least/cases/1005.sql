--Test least() function with collections 
create class t1 (a int, b timestamp);

select least({1000,99,88},{1000,98,99}) from db_root;
select least({1000,99,88},{1000,100,99}) from db_root;
select least({1001,99,88},{1000,100,99}) from db_root;

drop class t1;