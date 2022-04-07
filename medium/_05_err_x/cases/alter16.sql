-- error case , confirm it.
autocommit off;

rename class joe.employee_c as joe.employees_v;

rollback work;
rollback;
