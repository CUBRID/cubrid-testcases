-- [er]create several tables with different data types but the size is minus and tests the create syntax with conditions like 'numeric(-1)' ,'bit(-1)','bit varying(-1)' ,'char(-1)','nchar(-1)' and then report the minus syntax error

create class c_n (n numeric(-1)); 
create class c_b (b bit(-1));
create class c_vb (vb bit varying(-1)); 
create class c_c (c char(-1));
create class c_nc (nc nchar(-1));


drop c_n;
drop c_b;
drop c_vb;
drop c_c;
drop c_nc;