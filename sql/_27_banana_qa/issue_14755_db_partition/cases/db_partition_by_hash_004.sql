--test hash partition
--DML,DDL combination tests: drop -> add -> remove

drop table if exists  nation2;

CREATE TABLE nation2 (
  code CHAR (3),
  name VARCHAR (50)
)
PARTITION BY HASH (code) PARTITIONS 3; 

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;

--insert 49 rows
insert into nation2 values 
('ID','Indonesia'),
('IE','Ireland'),
('IL','Israel'),
('IN','India'),
('IQ','Iraq'),
('IR','Iran'),
('IS','Iceland'),
('IT','Italy'),
('IT','Ivory Coast'),
('JM','Jamaica'),
('JO','Jordan'),
('JP','Japan'),
('KE','Kenya'),
('KG','Kyrgyzstan'),
('KH','Kampuchea (Cambodia )'),
('KP','North Korea'),
('KR','Korea'),
('KT','Republic of Ivory Coast'),
('KW','Kuwait'),
('KZ','Kazakstan'),
('LA','Laos'),
('LB','Lebanon'),
('LC','St.Lucia'),
('LI','Liechtenstein'),
('LK','Sri Lanka'),
('LR','Liberia'),
('LS','Lesotho'),
('LT','Lithuania'),
('LU','Luxembourg'),
('LV','Latvia'),
('LY','Libya'),
('MA','Morocco'),
('MC','Monaco'),
('MD','Moldova, Republic of'),
('MG','Madagascar'),
('ML','Mali'),
('MM','Burma'),
('MN','Mongolia'),
('MO','Macao'),
('MS','Montserrat Is'),
('MT','Malta'),
('MT','Mariana Is'),
('MT','Martinique'),
('MU','Mauritius'),
('MV','Maldives'),
('MW','Malawi'),
('MX','Mexico'),
('MY','Malaysia'),
('MZ','Mozambique');

select count(*) from nation2;
select (select count(*) from nation2__p__p0)+(select count(*) from nation2__p__p1)+(select count(*) from nation2__p__p2) as count_num;
select * from db_partition where class_name = 'nation2' order by partition_name;

--dropping partitions
ALTER TABLE nation2 COALESCE PARTITION 1;
select count(*) from nation2;
--return error
ALTER TABLE nation2 COALESCE PARTITION 2;
ALTER TABLE nation2 COALESCE PARTITION 1;
select count(*) from nation2;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'nation2' order by partition_name;

--adding partitions
ALTER TABLE nation2 ADD PARTITION PARTITIONS 1;

--insert 11 rows
insert into nation2 values 
('NA','Namibia'),
('NE','Niger'),
('NG','Nigeria'),
('NI','Nicaragua'),
('NL','Netherlands'),
('NO','Norway'),
('NP','Nepal'),
('NP','Netheriands Antilles'),
('NR','Nauru'),
('NZ','New Zealand'),
('OM','Oman');
select count(*) from nation2 where code like 'N%';

ALTER TABLE nation2 ADD PARTITION PARTITIONS 2;
--insert 10 rows
insert into nation2 values 
('PA','Panama'),
('PE','Peru'),
('PF','French Polynesia'),
('PG','Papua New Cuinea'),
('PH','Philippines'),
('PK','Pakistan'),
('PL','Poland'),
('PR','Puerto Rico'),
('PT','Portugal'),
('PY','Paraguay');
select count(*) from nation2 ;

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
