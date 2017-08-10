drop table if exists o_m;

Create table o_m
(
Id int,
Name Varchar(255),
ParentId int,
Status Varchar(1),
I Varchar(1));

Insert Into o_m Values (1,'john',0,'N','Y');
Insert Into o_m Values (2,'ADMIN',1,'N','Y') 
Insert Into o_m Values (3,'ADMIN',1,'Y','Y') 

Select * from
o_m
Start with Id = 1
Connect By parentid = Prior Id
And Status = 'N' And ( I = 'N' Or Name = 'ADMIN' )  order by 1;

drop table if exists o_m;
