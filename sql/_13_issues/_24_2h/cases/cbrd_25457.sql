-- If you execute the AUTO_INCREMENT and DEFAULT properties individually using the ALTER TABLE MODIFY syntax on the same column, the two properties coexist in that column even though they should not.
-- If two properties are individually executed for the column, the property must be changed to the last executed property.

-- All table drop
DROP TABLE IF EXISTS tbl0, tbl1, tbl2, tbl3, tbl4, tbl5, tbl6;

-- 0. An error occurs when using auto_increment and default properties together.
CREATE TABLE tbl0 (col1 INTEGER AUTO_INCREMENT(1,1) default 0);

-- 1. In the case of a column without an attribute, use the alter statement to modify it to the default value of 0 and then modify it to auto_increment using the alter statement. 
CREATE TABLE tbl1 (col1 INTEGER);

alter table tbl1 modify col1 int default 0;
alter table tbl1 modify col1 int auto_increment;
show create table tbl1;
select attr_name, owner_name, data_type, default_value, comment from db_attribute where class_name = 'tbl1';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl1';

--Then, modify it to the default value of null.
alter table tbl1 modify col1 int default null;
show create table tbl1;
select attr_name, owner_name, data_type, default_value, comment from db_attribute where class_name = 'tbl1';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl1';

-- 2. In the case of a column without an attribute using the alter statement, modify it to auto_increment and then modify the default value to 0 using the alter statement.
CREATE TABLE tbl2 (col1 INTEGER);

alter table tbl2 modify col1 int auto_increment;
alter table tbl2 modify col1 int default 0;
show create table tbl2;
select attr_name, owner_name, data_type, default_value, comment from db_attribute where class_name = 'tbl2';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl2';

-- Add column comment using alter statement.
alter table tbl2 modify col1 int comment '2) test2';
show create table tbl2;
select attr_name, owner_name, data_type, default_value, comment from db_attribute where class_name = 'tbl2';

-- 3. Modifying the default attribute in a column with the auto_increment attribute using the alter statement.
CREATE TABLE tbl3 (col1 INTEGER AUTO_INCREMENT(1,1) NOT NULL);

alter table tbl3 modify col1 int default 0;
show create table tbl3;
select attr_name, owner_name, data_type, default_value from db_attribute where class_name = 'tbl3';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl3';

-- 4. Modify the auto_increment property on a column with the default property using the alter statement.
CREATE TABLE tbl4 (col1 INTEGER DEFAULT 0);

alter table tbl4 modify col1 int auto_increment;
show create table tbl4;
select attr_name, owner_name, data_type, default_value from db_attribute where class_name = 'tbl4';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl4';

-- Modify column type using alter statement.
ALTER TABLE tbl4 MODIFY col1 VARCHAR (200);

-- 5. Using the alter statement, modify the set default 0 property on a column with the auto_increment property using the alter column syntax.
CREATE TABLE tbl5 (col1 INTEGER AUTO_INCREMENT(1,1));

ALTER TABLE tbl5 ALTER COLUMN col1 SET default 0;
show create table tbl5;
select attr_name, owner_name, data_type, default_value from db_attribute where class_name = 'tbl5';
select unique_name, name, owner, current_val, increment_val from db_serial where class_name = 'tbl5';
 
-- 6. Using the alter statement, modify the default 0 attribute or default null in a column with the default attribute using the alter column statementi.
CREATE TABLE tbl6 (col1 INTEGER DEFAULT 2);

ALTER TABLE tbl6 ALTER COLUMN col1 SET default 0;
show create table tbl6;
select attr_name, owner_name, data_type, prec, default_value from db_attribute where class_name = 'tbl6';

ALTER TABLE tbl6 MODIFY col1 VARCHAR (200) default null;
show create table tbl6;
select attr_name, owner_name, data_type, prec, default_value from db_attribute where class_name = 'tbl6';

-- All table drop
drop table if exists tbl1, tbl2, tbl3, tbl4, tbl5, tbl6;
