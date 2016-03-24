autocommit off;
/*
: shadowing unique attribute with non-unique constraint from subclass 
  did not suppress unique constraint
*/
 create class foo(f_int int unique);
 insert into foo values(1);
 create class sub_foo as subclass of foo;
 alter sub_foo add attribute f_int int;
 insert into sub_foo values(1);
/*
 -> ERROR: Operation would have caused one or more unique constraint violations.
*/
rollback;
