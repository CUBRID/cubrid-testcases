drop table if exists t1;
CREATE TABLE t1 (jdoc JSON,a timestamp on update current_timestamp);
INSERT INTO t1(jdoc) VALUES('{"key1": "value1", "key2": "value2"}'); 
update t1 set jdoc=json_set(jdoc, '$.key1', '1');
select if(current_timestamp -a >=0 and current_timestamp -a<10,'ok','nok') from t1;

drop table if exists t1;
CREATE TABLE t1 (jdoc JSON ,a timestamp on update current_timestamp);
INSERT INTO t1(jdoc) VALUES('{"key1": "value1", "key2": "value2"}');
INSERT INTO t1(jdoc) VALUES('{"key1": "value1", "key2": "value2"}') on duplicate key update jdoc=json_set(jdoc, '$.key1', '1');
select * from t1;
INSERT INTO t1(jdoc) select jdoc from t1 on duplicate key update jdoc=json_set(jdoc, '$.key1', '1');  
select * from t1;


drop table if exists t1;
CREATE TABLE t1 (jdoc JSON,a timestamp on update current_timestamp);
INSERT INTO t1(jdoc) VALUES('{"key1": "value1", "key2": "value2"}');
update t1 set jdoc=json_replace(jdoc,'$.key2','2');
select if(current_timestamp -a >=0 and current_timestamp -a<10,'ok','nok') from t1;


drop table if exists t1;
CREATE TABLE t1 (jdoc JSON,a timestamp on update current_timestamp);
INSERT INTO t1(jdoc) VALUES('{"key1": "value1", "key2": "value2"}');
update t1 set jdoc=(JSON_OBJECT('key1', 1, 'key2', 'abc'));
select if(current_timestamp -a >=0 and current_timestamp -a<10,'ok','nok') from t1;
drop table if exists t1;

drop table if exists lnmp;
CREATE TABLE lnmp (
    `id` int(10)  NOT NULL AUTO_INCREMENT,
    `category` JSON,
    `tags` JSON,
     b timestamp on update current_timestamp, 
    PRIMARY KEY (`id`)
);
INSERT INTO `lnmp` (category, tags) VALUES ('{"id": 1, "name": "lnmp.cn"}', '[1, 2, 3]');
INSERT INTO `lnmp` (category, tags) VALUES (JSON_OBJECT('id', 2, 'name', 'php.net'), JSON_ARRAY(1, 3, 5));
SELECT * FROM lnmp order by 1;
SELECT * FROM lnmp WHERE category = CAST('{"id": 1, "name": "lnmp.cn"}' as JSON);
SELECT * FROM lnmp WHERE category = '{"id": 1, "name": "lnmp.cn"}';
SELECT * FROM lnmp WHERE JSON_CONTAINS(category, '1', '$.id')<>0;
SELECT * FROM lnmp WHERE JSON_CONTAINS(tags, '2')<>0;
UPDATE lnmp SET tags = '[1, 3, 4]' WHERE id = 1;
select if(current_timestamp -b >=0 and current_timestamp -b<10,'ok','nok') from lnmp where id=1;
drop table if exists lnmp;

