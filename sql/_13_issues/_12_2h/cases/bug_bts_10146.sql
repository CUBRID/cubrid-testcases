drop table if exists t1,t2;

SET NAMES utf8 COLLATE utf8_en_ci; 

--note: will fail to create on current design because duplicate values in enum type.
CREATE TABLE t1 (a ENUM('A', 'a')) collate utf8_en_ci; 
--test: will create successfully. we expect fail to create. please confirm whether support introducer.
CREATE TABLE t2 (a ENUM(_utf8'A',_utf8'a')) collate utf8_en_ci; 
;sc t2

drop table if exists t1,t2;

CREATE TABLE t1 (a ENUM('A ', 'a ')) collate utf8_en_ci; 
CREATE TABLE t2 (a ENUM(_utf8'A ',_utf8'a ')) collate utf8_en_ci; 

drop table if exists t1,t2;

CREATE TABLE t1 (a ENUM('( ', '( ')) collate utf8_en_ci; 
CREATE TABLE t2 (a ENUM(_utf8'( ',_utf8'( ')) collate utf8_en_ci; 

drop table if exists t1,t2;

CREATE TABLE t1 (a ENUM('- ', '- ')) collate utf8_en_ci; 
CREATE TABLE t2 (a ENUM(_utf8'- ',_utf8'- ')) collate utf8_en_ci; 

drop table if exists t1,t2;

CREATE TABLE t1 (a ENUM('- -', '- -')) collate utf8_en_ci; 
CREATE TABLE t2 (a ENUM(_utf8'- -',_utf8'- -')) collate utf8_en_ci; 

drop table if exists t1,t2;
set names iso88591 collate iso88591_bin;