--change_owner method auto increment table owner auto increment serial object owner

create class xxx (
a integer auto_increment,
b integer
);

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name='xxx';     
select name, owner.name from _db_serial where name='xxx_ai_a';
call change_owner('xxx','public') on class db_root;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name='xxx';
select name, owner.name from _db_serial where name='xxx_ai_a';

drop class public.xxx;

