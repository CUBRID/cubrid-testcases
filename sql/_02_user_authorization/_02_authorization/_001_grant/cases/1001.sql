--+ holdcas on;
--[er]test class as colum type using OID(grant and revoke)
--create user1 and user2,create class xoo by user1,grant privilege of select to user2,create class zoo by user2 using class as colum type,into data to  class zoo using OID,revoke privilege of select from user2 by user1,create poo by user2,retrieve zoo with variable :o,then report semantic error

call login('dba','') on class db_user;
create user user1;
create user user2;

call login('user1', '') on class db_user ;

create table xoo ( id int); 
insert into xoo values(10000); 
grant select on xoo to user2; 

call login('user2', '') on class db_user ;

create table zoo ( id int, x xoo); 
insert into zoo values(2, (select xoo from xoo)); 

call login('user1', '') on class db_user ;

revoke select on xoo from user2; 

call login('user2', '') on class db_user ;
select x into :o from zoo;

call login('user2', '') on class db_user ;
create class poo ( id int); 
call login('user2', '') on class db_user ;
select :o.id from db_root; 
call login('user2', '') on class db_user ;
insert into poo values(:o.id); 


select * from poo order by 1;


call login('dba','') on class db_user;
drop xoo, zoo, poo;
drop user user1;
drop user user2;

--+ holdcas off;
