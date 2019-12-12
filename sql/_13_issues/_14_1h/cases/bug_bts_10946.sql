
--+ holdcas on;

DROP TABLE IF EXISTS table1;

CREATE TABLE table1 (
col1 VARCHAR(10) DEFAULT '' 
);

desc table1;
select db_attribute.attr_name,db_attribute.default_value from db_attribute where class_name='table1' order by 1;
SHOW CREATE TABLE table1 ;
DROP TABLE IF EXISTS table1;

--+ holdcas off;
commit;

