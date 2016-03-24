autocommit off;
create class foo (n int);
insert into foo values (1);
(select k from foo, table({n-1,n+1}) t(k))
union
(select n from foo);
(select cast(k as int) from foo, table({n-1,n+1}) t(k))
union
(select n from foo);
rollback;
