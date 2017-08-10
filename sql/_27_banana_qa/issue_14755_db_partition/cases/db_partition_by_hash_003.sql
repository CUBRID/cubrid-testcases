--test hash partition
--DML,DDL combination tests: create -> drop -> remove


drop table if exists  nation2;

CREATE TABLE nation2 (
  code CHAR (3),
  name VARCHAR (50)
)
PARTITION BY HASH (code) PARTITIONS 4; 

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;
--insert 45 rows
insert into nation2 values 
('AD','Andorra'),
('AE','United Arab Emirates'),
('AF','Afghanistan'),
('AG','Antigua and Barbuda'),
('AI','Anguilla'),
('AL','Albania'),
('AM','Armenia'),
('AM','Ascension'),
('AO','Angola'),
('AR','Argentina'),
('AT','Austria'),
('AU','Australia'),
('AZ','Azerbaijan'),
('BB','Barbados'),
('BD','Bangladesh'),
('BE','Belgium'),
('BF','Burkina-faso'),
('BG','Bulgaria'),
('BH','Bahrain'),
('BI','Burundi'),
('BJ','Benin'),
('BL','Palestine'),
('BM','Bermuda Is.'),
('BN','Brunei'),
('BO','Bolivia'),
('BR','Brazil'),
('BS','Bahamas'),
('BW','Botswana'),
('BY','Belarus'),
('BZ','Belize'),
('CA','Canada'),
('CA','Cayman Is.'),
('CF','Central African Republic'),
('CG','Congo'),
('CH','Switzerland'),
('CK','Cook Is.'),
('CL','Chile'),
('CM','Cameroon'),
('CN','China'),
('CO','Colombia'),
('CR','Costa Rica'),
('CS','Czech'),
('CU','Cuba'),
('CY','Cyprus'),
('CZ','Czech Republic');

select count(*) from nation2;
select  (select count(*) from nation2__p__p0)+
	(select count(*) from nation2__p__p1)+
	(select count(*) from nation2__p__p2)+
	(select count(*) from nation2__p__p3) as count_num;

--adding partitions
ALTER TABLE nation2 ADD PARTITION PARTITIONS 1;

select * from db_partition where class_name = 'nation2' order by partition_name;
--insert 13 rows
insert into nation2 values 
('DE','Germany'),
('DJ','Djibouti'),
('DK','Denmark'),
('DO','Dominica Rep.'),
('DZ','Algeria'),
('EC','Ecuador'),
('EE','Estonia'),
('EG','Egypt'),
('ES','Spain'),
('ET','Ethiopia'),
('FI','Finland'),
('FJ','Fiji'),
('FR','France');

select count(*) from nation2 where code like 'D%';

ALTER TABLE nation2 ADD PARTITION PARTITIONS 2;

--insert 17 rows
insert into nation2 values 
('GA','Gabon'),
('GB','United Kiongdom'),
('GD','Grenada'),
('GE','Georgia'),
('GF','French Guiana'),
('GH','Ghana'),
('GI','Gibraltar'),
('GM','Gambia'),
('GN','Guinea'),
('GR','Greece'),
('GT','Guatemala'),
('GU','Guam'),
('GY','Guyana'),
('HK','Hongkong'),
('HN','Honduras'),
('HT','Haiti'),
('HU','Hungary');

select count(*) from nation2 where code like 'H%';

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;

--dropping partitions
ALTER TABLE nation2 COALESCE PARTITION 1;
select count(*) from nation2;

ALTER TABLE nation2 COALESCE PARTITION 3;
select count(*) from nation2;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;

--remove partitioning
ALTER TABLE nation2 REMOVE PARTITIONING;
select count(*) from nation2;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;

DROP nation2;
