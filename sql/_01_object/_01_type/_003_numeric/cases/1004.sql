--create table,create view based on the created table,select data from the table and view,drop the table and view

create class c1 (n numeric, 
b bit(5), vb bit varying(5), 
c char(5), nc nchar(5), 
v varchar(5), nv nchar varying(5)); 

insert into c1 values (0.1, 
B'01', B'01', 
'01', N'01', 
'01', N'01'); 

create view v1 (n numeric(0), 
b bit(0), vb bit varying(0), 
c char(0), nc nchar(0), 
v varchar(0), nv nchar varying(0)) 
as 
select n, b, vb, c, nc, v, nv from c1; 


select * from c1; 
select * from v1;  


drop class c1;
drop vclass v1;
