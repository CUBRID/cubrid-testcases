--delete where count(*) = 

create class tb( 
col1 varchar, 
col2 char(10), 
col3 int 
); 
 
 insert into tb values('varchar01', 'char01', 3); 
 insert into tb values('varchar02', 'char02', 4); 
insert into tb values('varchar03', 'char03', 5); 
 
 select * from tb order by 1; 
 
delete from tb where col3=count(col3); 

drop tb;