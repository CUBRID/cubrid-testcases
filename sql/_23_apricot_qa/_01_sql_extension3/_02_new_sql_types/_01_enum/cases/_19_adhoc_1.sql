 CREATE TABLE MyTable(MyEnum ENUM ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255', '256', '257', '258', '259', '260', '261', '262', '263', '264', '265', '266', '267', '268', '269', '270', '271', '272', '273', '274', '275', '276', '277', '278', '279', '280', '281', '282', '283', '284', '285', '286', '287', '288', '289', '290', '291', '292', '293', '294', '295', '296', '297', '298', '299', '300'), primary key(MyEnum));

 INSERT INTO MyTable VALUES ('5');

 INSERT INTO MyTable VALUES ('10');

 ALTER TABLE MyTable MODIFY COLUMN MyEnum varchar(1);

drop table mytable;

CREATE TABLE MyTable(MyEnum ENUM ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255', '256', '257', '258', '259', '260', '261', '262', '263', '264', '265', '266', '267', '268', '269', '270', '271', '272', '273', '274', '275', '276', '277', '278', '279', '280', '281', '282', '283', '284', '285', '286', '287', '288', '289', '290', '291', '292', '293', '294', '295', '296', '297', '298', '299', '300'), primary key(MyEnum));

INSERT INTO MyTable VALUES ('1');

INSERT INTO MyTable VALUES ('10');

ALTER TABLE MyTable MODIFY COLUMN MyEnum varchar(5);

drop table mytable;

CREATE TABLE MyTable(MyEnum ENUM ('true', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255', '256', '257', '258', '259', '260', '261', '262', '263', '264', '265', '266', '267', '268', '269', '270', '271', '272', '273', '274', '275', '276', '277', '278', '279', '280', '281', '282', '283', '284', '285', '286', '287', '288', '289', '290', '291', '292', '293', '294', '295', '296', '297', '298', '299', '300'), primary key(MyEnum));

drop table mytable;

CREATE TABLE MyTable(MyEnum ENUM ('aib', 'aic'), primary key(MyEnum)) ;

INSERT INTO MyTable VALUES ('aib');

INSERT INTO MyTable VALUES ('aic');

select HEX(MyEnum) from MyTable  order by 1;

select MyEnum+0 from MyTable order by 1;

ALTER TABLE MyTable MODIFY COLUMN MyEnum varchar(5);

drop table mytable;




drop table if exists t1;

CREATE TABLE  t1  (a  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP , b  enum('c 1','b 1','a 1') NOT NULL DEFAULT 'c 1' primary key) ;

INSERT INTO t1(b) VALUES ('a 1'),('c 1'),('b 1');

select MAX(b) from t1;

select b ,count(*) from t1 group by b order by 1 ;

select b ,count(*) from t1 group by b order by cast( b as varchar) limit 2;

select b ,count(*),sum(b)from t1 group by b order by cast( b as char) limit 65535;

select b ,count(*),sum(b)from t1 group by b order by cast( b as string) limit 65535;

select b from t1  WHERE ROWNUM <20 and rownum>0 group by b order by 1;

select ROWNUM,b from t1  WHERE ROWNUM <20 and rownum>0 group by b order by 2;

select ROWNUM,b from t1  WHERE ROWNUM <20 and rownum>0 group by b order by cast( b as int);


drop table t1;


create table t1 (df decimal(5,1));
insert into t1 values(1.1);
--- 100,106 ----
insert into t1 values(1.1);
select distinct * from t1;
drop table t1;


drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

CREATE TABLE  t1  (a  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP , b  enum('1','2','3','4','5','6','7','8','9'),c int primary key );
INSERT INTO t1(b,c) select '1',rownum from db_class,db_class s2 limit 1;
CREATE TABLE  t2  (a  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP , b  enum('1','2','3','4','5','6','7','8','9') ,c int primary key);
INSERT INTO t2(b,c) select '1',rownum from db_class,db_class s2 limit 1;
CREATE TABLE  t3  (a  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP , b  enum('1','2','3','4','5','6','7','8','9'),c int primary key );
INSERT INTO t3(b,c) select '1',rownum from db_class,db_class s2 limit 1;

update  t1 inner join t2  on t1.b=t2.b  inner join t3 on t1.b=t3.b set t3.b='7',t1.b='7' , t2.b='7' ;

select t1.b,t1.c from t1 inner join t2  on t1.b=t2.b  inner join t3 on t1.b=t3.b order by 1;

drop table t1,t2,t3;







drop table if exists t1;
CREATE TABLE t1(MyEnum ENUM ('-32768', '32767','-2147483647','2147483648'), primary key(MyEnum)) ;

INSERT INTO t1 VALUES ('-32768'),('32767'),('-2147483647'),('2147483648');
select * from t1 order by 1;

select * from t1 where cast( MyEnum as int)> 1 order by 1;

select * from t1 where cast( MyEnum as string)> 32000 order by 1;

select cast( MyEnum as string) from t1 order by 1 ;



drop table if exists t1;
CREATE TABLE t1(MyEnum ENUM ('&', '*','!','\'), primary key(MyEnum)) ;
INSERT INTO t1 VALUES ('&'),('*'),('!'),('\');

select * from t1 order by 1;
select * from t1 where cast( MyEnum as string)> '' order by 1;

select * from t1 where cast( MyEnum as string) = '&' order by 1;

select * from t1 where cast( MyEnum as string) like '&' order by 1;

select * from t1 where cast( MyEnum as string) != '!!' order by 1;

select count(*),MyEnum from t1 where cast( MyEnum as string) != '!'  group by MyEnum limit 10;

--error occurs
select * from t1 where cast( MyEnum as string) != '!!'  and rownum!=rownum  order by 1;

select * from t1 where cast( MyEnum as string) != '!!'  or rownum=rownum  order by 1;

drop table t1;




drop table if exists t1;
CREATE TABLE t1(a enum('Y', 'N') primary key default 2);
alter table t1 add column b enum('Y', 'N') default 1;
alter table t1 add column c enum('Y', 'N') default 1;
alter table t1 add column d enum('Y', 'N') default 1;
alter table t1 add column e enum('Y', 'N') default 1;
alter table t1 add column f enum('Y', 'N') default 1;
alter table t1 change e e int default 1;
alter table t1 change f f int default 0;
alter table t1 change e e enum('Y', 'N') default 1;
alter table t1 change f f enum('Y', 'N') default 1;

alter table t1 add column g enum('Y', 'N', 'Y1', 'N1') default 1;

alter table t1 drop primary key ;

alter table t1  add column h double primary key default 0;
insert into t1(h) select rownum from db_class,db_class s1 limit 1000;
show columns from t1;
drop table t1;


drop table if exists t1;
CREATE TABLE t1(a enum('Y', 'N'),b int) partition by hash(b) partitions 2 ;
CREATE TABLE t2(a enum('Y', 'N'));
alter table t2 add column b int;
alter table t2 partition by hash(b) partitions 2;      
drop table t1;
drop table t2;
drop table if exists t1;

CREATE TABLE t1(a enum('&nbsp', '&nbsp;') ,b int, INDEX i_index(a desc));
INSERT INTO t1 VALUES ('&nbsp',1);
select * from t1 order by 1;
drop table t1;

drop table if exists t1;
CREATE TABLE t1(a enum('&nbsp', '&nbsp;') ,b enum('&nbsp', '&nbsp;'), primary key(a ,b desc),INDEX i_t_ab(a desc,b ASC));
INSERT INTO t1 VALUES ('&nbsp','&nbsp');

CREATE TABLE t(a varchar(10),b varchar(10)) REPLACE AS SELECT * FROM t1;

select * from t1;
drop table t, t1;


