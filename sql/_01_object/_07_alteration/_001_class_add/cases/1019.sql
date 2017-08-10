--[er]create class and alter it to add -1 precision nchar and varchar data type attribute


create class c_nc (it int);
alter class  c_nc add attribute nc nchar(-1);
create class c_v (it int);
alter class  c_v add attribute v varchar(-1);
drop class c_nc;
drop class c_v;
