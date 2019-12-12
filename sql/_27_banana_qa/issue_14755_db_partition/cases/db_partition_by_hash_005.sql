--test hash partition
--DML,DDL combination tests: remove -> add -> drop

drop table if exists  nation2,nation;

CREATE TABLE nation2 (
  code CHAR (3),
  name VARCHAR (50)
)
PARTITION BY HASH (code) PARTITIONS 3; 

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;
--insert 30 rows
insert into nation2 values 
('QA','Qatar'),
('QA','Reunion'),
('RO','Romania'),
('RU','Russia'),
('SA','Saudi Arabia'),
('SB','Solomon Is'),
('SC','Seychelles'),
('SD','Sudan'),
('SE','Sweden'),
('SG','Singapore'),
('SI','Slovenia'),
('SK','Slovakia'),
('SL','Sierra Leone'),
('SM','San Marino'),
('SM','Samoa Eastern'),
('SM','San Marino'),
('SN','Senegal'),
('SO','Somali'),
('SR','Suriname'),
('ST','Sao Tome and Principe'),
('SV','EI Salvador'),
('SY','Syria'),
('SZ','Swaziland'),
('TD','Chad'),
('TG','Togo'),
('TH','Thailand'),
('TJ','Tajikstan'),
('TM','Turkmenistan'),
('TN','Tunisia'),
('TO','Tonga');

select count(*) from nation2;
select (select count(*) from nation2__p__p0)+(select count(*) from nation2__p__p1)+(select count(*) from nation2__p__p2) as count_num;

--remove partitioning
ALTER TABLE nation2 REMOVE PARTITIONING;
select count(*) from nation2;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;

--alter table to partition table
ALTER TABLE nation2 PARTITION BY HASH (code) PARTITIONS 1; 

--insert 9 rows
insert into nation2 values 
('TR','Turkey'),
('TT','Trinidad and Tobago'),
('TW','Taiwan'),
('TZ','Tanzania'),
('UA','Ukraine'),
('UG','Uganda'),
('US','United States of America'),
('UY','Uruguay'),
('UZ','Uzbekistan');
select count(*) from nation2 where code like 'U%';

rename table nation2 as nation;

select * from db_partition where class_name = 'nation' order by partition_name;
--adding partitions
ALTER TABLE nation ADD PARTITION PARTITIONS 2;

--insert 9 rows
insert into nation values 
('VC','Saint Vincent'),
('VE','Venezuela'),
('VN','Vietnam'),
('YE','Yemen'),
('YU','Yugoslavia'),
('ZA','South Africa'),
('ZM','Zambia'),
('ZR','Zaire'),
('ZW','Zimbabwe');
select count(*) from nation ;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation%' ORDER BY 2 ASC;

select * from db_partition where class_name = 'nation' order by partition_name;
--dropping partitions
ALTER TABLE nation COALESCE PARTITION 1;
select count(*) from nation;
--return error
ALTER TABLE nation COALESCE PARTITION 2;
ALTER TABLE nation COALESCE PARTITION 1;
select count(*) from nation;

select * from db_partition where class_name = 'nation' order by partition_name;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation%' ORDER BY 2 ASC;

DROP nation;
