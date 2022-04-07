autocommit off;

rename vclass joe.employees_v as db_user;
rollback work;
rollback;
