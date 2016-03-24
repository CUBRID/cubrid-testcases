autocommit off;
create user aaa ;
create user bbb groups aaa;
create user ccc groups bbb members aaa;
create user nuser password ''
groups dba, public
members dba, public;
create user aaa groups dba members public;
rollback work;
rollback;
