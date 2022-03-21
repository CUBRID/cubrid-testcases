autocommit off;
call login ('joe', '') on class db_user;
revoke all on shipment_c from public;
grant select on shipment_c to user1;
call login ('user1', '') on class db_user;
grant select on joe.shipment_c to user2;
call login ('dba', '') on class db_user;
rollback;
