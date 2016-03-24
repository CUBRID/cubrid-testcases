autocommit off;
call login ('joe', '') on class db_user;
grant all privileges on shipment_v to public;
revoke select on shipment_v from user1;
call login ('dba', '') on class db_user;
rollback;
