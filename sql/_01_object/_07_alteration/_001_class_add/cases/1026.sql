-- add attribute of Unique when date of table not exist
create class c_nc (it int);

alter class  c_nc add attribute nc nchar(2) Unique;

select * from c_nc;
drop class c_nc;