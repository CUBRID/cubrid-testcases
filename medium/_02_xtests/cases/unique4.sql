autocommit off;
create class foo (a int, b int unique, c float, unique(a,c));
create class bar as subclass of foo (d int, e double unique);
select * from db_class where class_name in ('foo', 'bar');
rollback
rollback;
