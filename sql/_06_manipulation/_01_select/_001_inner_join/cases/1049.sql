set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
-- [er]tests complex select with special collections 

call login('dba', '') on class db_user;
create user user1;
create user user2;

call login('user1', '') on class db_user;

   create table xoo ( id int);
   insert into xoo values(10000);
   grant select on xoo to user2;

call login('user2', '') on class db_user;

   create table zoo ( id int, x user1.xoo);
   insert into zoo values(2, (select xoo from user1.xoo));

call login('user1', '') on class db_user;

   revoke select on xoo from user2;

call login('user2', '') on class db_user;
   select x into :oid from zoo;

   create class poo ( id int);

   select :oid.id from db_root;
   insert into poo values(:oid.id);
   select * from poo;





call login('dba', '') on class db_user;

drop user1.xoo;
drop user2.poo;
drop user2.zoo;
drop user user1;
drop user user2;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
