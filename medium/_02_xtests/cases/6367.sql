autocommit off;
/* converting from NUMERIC to INT's truncate instead of round-off */
 create class foo(f numeric(2,1));
 insert into foo values(1.9);
 select cast(f as int) from foo;
/*
=== <Result of SELECT Command in Line 1> ===
   cast(f as integer)
=====================
                    2
*/
rollback;
