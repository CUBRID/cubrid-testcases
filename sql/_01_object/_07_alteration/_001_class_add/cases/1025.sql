-- add attribute of Shared when date of table not exist
create class c_nc (it int);

alter class  c_nc add attribute nc string Shared 'a';

select * from c_nc;

drop class c_nc;