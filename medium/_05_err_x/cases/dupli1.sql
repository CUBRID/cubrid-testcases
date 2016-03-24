autocommit off;
create class twin (t int);
update twin set t = 1, t = 2;
rollback;
