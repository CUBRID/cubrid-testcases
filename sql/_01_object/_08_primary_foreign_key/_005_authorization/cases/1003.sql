--+ holdcas on;
--[er]create FK to class owned by other user that only UPDATE authorization

call login('dba','') on class db_user;
create user user1;
create user user2;

call login('user1', '') on class db_user ;

create table xoo ( id int PRIMARY KEY); 
insert into xoo values(10000); 
grant update on xoo to user2; 

call login('user2', '') on class db_user ;


create table yoo ( a int ,b VARCHAR(10),c INT,FOREIGN KEY (c) REFERENCES xoo(id)); 
insert into yoo values(1,'ssss',10000); 



call login('dba','') on class db_user;


drop TABLE yoo;
drop TABLE xoo;

drop user user1;
drop user user2;


--+ holdcas off;
