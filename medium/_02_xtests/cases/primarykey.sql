autocommit off;
create table pktest( col1 int, primary key(col1));
;schema pktest
rollback;
create table pktest( col1 int, constraint c1 primary key(col1));
;schema pktest
rollback;
create table pktest( col1 int primary key);
;schema pktest
rollback;
rollback;
