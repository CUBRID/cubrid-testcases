autocommit off;

rename vclass joe.employees_v as _db_user;
rollback work;
rollback;
