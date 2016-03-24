--
create table xoo ( a int);
create table yoo ( reuse_oid int);
select a as reuse_oid from xoo;

drop xoo;
drop yoo;
