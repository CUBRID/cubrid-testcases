autocommit off;
create class foo1 (a int unique);
create class foo2 as subclass of foo1;
alter class foo2 add a int;            -- Shadows inherited attribute
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name in ('foo1', 'foo2');
rollback;
