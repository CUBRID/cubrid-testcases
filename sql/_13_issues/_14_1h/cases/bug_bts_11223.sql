--+ holdcas on;
drop table if exists e;
CREATE TABLE e(m nchar COLLATE iso88591_bin DEFAULT N'', n nchar varying COLLATE iso88591_bin DEFAULT N'') COLLATE iso88591_bin;
show create table e;

SELECT class_of, attr_name, attr_type, from_class_of, from_attr_name, def_order, [data_type], default_value, domains, is_nullable FROM [_db_attribute] WHERE attr_name='n';

drop table if exists e;
--+ holdcas off;
commit;
