set names utf8;

select class_name from db_class order by 1 collate utf8_bin limit 1;
--select class_name from db_class order by ascii('a') collate utf8_gen limit 1;
--select class_name from db_class order by length(' ') collate utf8_fr_exp_ab limit 1;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class order by 1,2 collate utf8_bin,3 limit 1;

set names utf8;
