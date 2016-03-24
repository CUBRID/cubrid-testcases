-- Test monetary of data type with scale and precision


create class xoo ( id monetary); 

insert into xoo values( 
           -111111111111111111111.123456789012345); 
insert into xoo values( 
           111111111111111111111.123456789012345); 
select * from xoo;
select id+1 from xoo;

drop xoo;