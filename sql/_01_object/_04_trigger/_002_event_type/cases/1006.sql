--create class ooo,insert data to this table,create class ppp, insert data to this table,create trigger named ooo_tr ,set trigger trace on then drop class and trigger

create class ooo ( x int, y int); 
insert into ooo values(10, 100); 
insert into ooo values(11, 100); 
insert into ooo values(12, 100); 
insert into ooo values(13, 100); 
insert into ooo values(14, 100); 
create class ppp ( x int, y int); 
insert into ppp values(20, 200); 

create trigger ooo_tr 
after insert on ooo 
execute update object obj set ooo.x = ( select y from ppp where ppp.x = ooo.x); 

set trigger trace on;

insert into ooo values(20,200); 
select * from ooo order by 1,2;


drop trigger ooo_tr; 
drop ooo; 
drop ppp; 


create class ooo ( x int, y int); 
insert into ooo values(10, 100); 
insert into ooo values(11, 100); 
insert into ooo values(12, 100); 
insert into ooo values(13, 100); 
insert into ooo values(14, 100); 
create class ppp ( x int, y int); 
insert into ppp values(20, 200); 

create trigger ooo_tr 
after insert on ooo 
execute update object obj set ooo.x = ( select y from ppp where ppp.x = ooo.x); 

set trigger trace on;

insert into ooo values(20,200); 
select * from ooo order by 1,2;



drop trigger ooo_tr;
drop table ooo;
drop table ppp;
