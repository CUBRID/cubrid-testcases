--+ holdcas on;
drop table if exists t;
CREATE TABLE t (
  `id` INT NOT NULL AUTO_INCREMENT,
  `txt` VARCHAR(10) DEFAULT NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

INSERT INTO t (txt) VALUES ('b');
select if(current_timestamp-ts>=0 and current_timestamp-ts<10,'ok','nok') from t;
set @a=(select ts from t);
select sleep(5);
UPDATE t SET `txt`='b' WHERE `id`='1';
--select * from t;
select if(ts-to_timestamp(@a)>=5 and ts-to_timestamp(@a)<10,'ok','nok') from t;


drop table if exists t;
CREATE TABLE t (
  `id` INT NOT NULL AUTO_INCREMENT,
  `txt` VARCHAR(10) DEFAULT NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

INSERT INTO t (txt) VALUES ('b');
--select * from t;
select if(current_timestamp-ts>=0 and current_timestamp-ts<10,'ok','nok') from t;
set @a=(select ts from t);
select sleep(5);
UPDATE t SET `txt`='b';
--select * from t;
select if(ts-to_timestamp(@a)>=5 and ts-to_timestamp(@a)<10,'ok','nok') from t;


drop table if exists t;
CREATE TABLE t (
  `id` INT NOT NULL AUTO_INCREMENT,
  `txt` VARCHAR(10) DEFAULT NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

INSERT INTO t (txt) VALUES ('b');
--select * from t;
set @a=(select ts from t);
select sleep(2);
UPDATE t SET `txt`='b' WHERE `id`='0';
--select * from t;
select if(ts - to_timestamp(@a)=0,'ok','nok') from t;
drop table t;
drop variable @a;


--+ holdcas off;
