autocommit off;
create class foo;
alter class foo add class attribute bar string;
drop foo;
rollback;
