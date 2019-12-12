--[er]create class and alter it to add zero precision nchar/varchar attribute


create class c_nc (it int);
alter class  c_nc add attribute nc nchar(0);
create class c_v (it int);
alter class  c_v add attribute v varchar(0);

drop class c_nc;
drop class c_v;
