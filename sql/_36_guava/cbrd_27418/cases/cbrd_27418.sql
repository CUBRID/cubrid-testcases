/**
 *  This test case verifies CBRD-27418: the four sensitivity label tables have the
 *  specified columns, OBJECT domains and keys but no foreign key.
 */
-- 1. the label tables have the specified column types, OBJECT domains and NOT NULL columns, in order
select class_name, def_order, attr_name, data_type, prec, domain_class_name, is_nullable
from db_attribute
where class_name in ('_db_sensitivity_label', '_db_sensitivity_label_grade', '_db_sensitivity_label_info_type',
                     '_db_sensitivity_label_source')
order by class_name, def_order;

-- 2. the label tables have the specified primary keys and the grade_level unique key, and no foreign key
select i.class_name, i.index_name, i.is_unique, i.is_primary_key, i.is_foreign_key, k.key_order, k.key_attr_name
from db_index i, db_index_key k
where i.class_name = k.class_name and i.index_name = k.index_name
  and i.class_name in ('_db_sensitivity_label', '_db_sensitivity_label_grade', '_db_sensitivity_label_info_type',
                       '_db_sensitivity_label_source')
order by i.class_name, i.index_name, k.key_order;
