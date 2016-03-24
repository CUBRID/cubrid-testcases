autocommit off;
create table foo (a int, b int);
create table bar (a int, b int);
rollback;
autocommit on;
