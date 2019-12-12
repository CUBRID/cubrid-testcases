--+ holdcas on;

create table sourcetb (a int);
grant select on sourcetb to public;

call login('public', '') on class db_user;
create table targettb like sourcetb;

CREATE TABLE tblx LIKE db_root;

CREATE TABLE tblx LIKE db_class;

call login('dba', '') on class db_user;
drop table sourcetb;

drop table targettb;

--+ holdcas off;
