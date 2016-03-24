autocommit off;
/*There is a problem with shared attributes being used in a path expression....
*/
create class a3 (foo3 int, bar3 int shared NULL);
create class a2 (foo2 a3);
create class a1 (foo1 a2);
alter class a3 modify bar3 int default 333;
insert into a1 (foo1) values ( (insert into a2 (foo2) values (
     (insert into a3 (foo3) values (2)))));
select foo1.foo2.foo3 from a1;
select foo1.foo2.bar3 from a1;
/* yields :
Internal system error at pt_xasl.c line 1671resolving attribute name bar3pt_to_regu_variable failed on a1.foo1.foo2.bar3
pt_to_xasl failed on select a1.foo1.foo2.bar3 from a1 a1
In the SQL/X command from line 1671,
ERROR: System error (generate).
0 command(s) successfully processed.
*/
rollback;
