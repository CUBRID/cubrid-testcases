-- add class  attribute when date of table not exist
create class c_nc (it int);

alter class  c_nc add class attribute clar STRING;

select * from c_nc;

drop class c_nc;