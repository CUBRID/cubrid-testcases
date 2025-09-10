autocommit off;
create class foo (a int, b int unique, c float, unique(a,c));
create class bar as subclass of foo (d int, e double unique);
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name in ('foo', 'bar');
rollback;
rollback;
