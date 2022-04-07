--+ holdcas on;
-- [er]create FK to class owned by other user not authorized

call login('dba','') on class db_user;
create user user1;
create user user2;

call login('user1', '') on class db_user ;

create table xoo ( id int); 
insert into xoo values(10000); 

call login('user2', '') on class db_user ;


create table yoo ( a int ,b VARCHAR(10),c INT,FOREIGN KEY (c) REFERENCES user1.xoo(id)); 
insert into yoo values(10000); 



call login('dba','') on class db_user;

drop TABLE user2.yoo;

drop TABLE user1.xoo;
drop user user1;
drop user user2;


--+ holdcas off;
