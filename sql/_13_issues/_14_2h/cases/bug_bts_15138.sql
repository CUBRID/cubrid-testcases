drop table if exists foo;
create table foo (a varchar(10), b int) reuse_oid;
insert into foo values ( 'aaaaaaaa', 1);
 
select substring(a, 5,2) from foo union all select substring(a, 5, 2) from foo;
select insert(a, 2, 2, 'dbsql') from foo union all select insert(a, 2, 2,'cubrid') from foo;
select elt(b, 'string1', 'string2', 'string3') from foo union all select elt(b, 'string1', 'string2', 'string3') from foo;
select inet_ntoa(b) from foo union all select inet_ntoa(b) from foo ;

drop table if exists foo;
