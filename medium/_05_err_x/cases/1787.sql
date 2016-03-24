autocommit off;
create class s2(a real);
create class c under s1, s2
inherit a of s2 as b;
alter s1 add b char;
rollback;
