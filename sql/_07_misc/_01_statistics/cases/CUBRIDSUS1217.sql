--scenario for CUBRIDSUS1217

select class_name, owner_name, class_type, is_system_class, tde_algorithm, statistics_strategy, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name = 'db_ha_apply_info';
select attr_name, class_name from db_attribute where class_name = 'db_ha_apply_info' order by 1;