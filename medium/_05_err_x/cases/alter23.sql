autocommit off;

rename vclass employees_v as db_user;
rollback work;
rollback;
