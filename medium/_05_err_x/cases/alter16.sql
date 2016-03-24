-- error case , confirm it.
autocommit off;


rename class employee_c as employees_v;

rollback work;
rollback;
