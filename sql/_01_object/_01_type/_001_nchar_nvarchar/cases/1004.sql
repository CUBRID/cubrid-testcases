-- delete data from  which create table using int  and then insert and query values and drop table

create table xx (i int); 
delete from xx; 
insert into xx values (1); 
delete from xx; 
insert into xx values (2); 
select * from xx;

drop xx;