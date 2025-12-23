-- [er]create a table with a primary key ,create a table with a foreign key references the primary key,drop the foreign key

CREATE TABLE album(
  id CHAR(10) PRIMARY KEY,
  title VARCHAR(100),
  artist VARCHAR(100)
);

CREATE TABLE track(
  album CHAR(10),
  dsk INTEGER,
  posn INTEGER,
  song VARCHAR(255),
  FOREIGN KEY (album) REFERENCES album(id)
);

ALTER TABLE track DROP ATTRIBUTE album;
select * from db_index_key 
where class_name in ('album','track') order by 2,1;

select index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, status, referential_index_class_owner_name, referential_index_class_name, referential_index_name, delete_rule, update_rule, referential_match_option, index_type, deduplicate_key_level, comment from db_index where class_name in ('album', 'track') order by 1,2;

select attr_name, class_name,owner_name, attr_type,def_order, from_class_name, from_owner_name, from_attr_name, data_type, prec, scale, charset, collation, domain_class_name, domain_owner_name, default_value, is_nullable, comment from db_attribute
where class_name in ('album','track') order by 2,1;
drop class track;
drop class album;