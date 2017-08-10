-- add class  attribute when date of table exist
create class c_nc (it int);

insert into c_nc values (2);

alter class  c_nc add class attribute clar STRING;

select * from c_nc;

drop class c_nc;