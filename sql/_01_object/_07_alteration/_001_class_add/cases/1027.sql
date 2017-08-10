-- add attribute of  PRIMARY KEY when date of table not exist
create class c_nc (it int);

alter class  c_nc add attribute nc nchar(2)  PRIMARY KEY;

select * from c_nc;
drop class c_nc;