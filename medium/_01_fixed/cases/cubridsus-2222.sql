--this case was added for cubridsus-2222

SELECT a.index_name,a.is_unique,b.key_attr_name,b.asc_desc FROM db_index a,db_index_key b WHERE a.class_name=b.class_name AND a.index_name=b.index_name AND a.class_name='kitsch_c' AND is_primary_key='NO' AND is_foreign_key='NO' ORDER BY b.key_order;
