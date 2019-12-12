
--+ holdcas on;

--example01
drop table if exists [partition];

CREATE TABLE [partition](id integer AUTO_INCREMENT(1,1) NOT NULL,
ch character(10) COLLATE iso88591_bin ,
CONSTRAINT pk PRIMARY KEY(id,ch)
) COLLATE iso88591_bin ;

ALTER TABLE [partition] PARTITION BY RANGE (ch) (PARTITION p1 VALUES LESS THAN ('100'), PARTITION p2 VALUES LESS THAN ('200'), PARTITION p3 VALUES LESS THAN ('300'));

show create table [partition];

drop table if exists [partition];

--example02
drop table if exists [partition];

CREATE TABLE [partition](id integer AUTO_INCREMENT(1,1) NOT NULL,
ch character(10) COLLATE iso88591_bin ,
CONSTRAINT pk PRIMARY KEY(id,ch)
) COLLATE iso88591_bin ;

ALTER TABLE [partition] PARTITION BY RANGE ([ch]) (PARTITION p1 VALUES LESS THAN ('100'), PARTITION p2 VALUES LESS THAN ('200'), PARTITION p3 VALUES LESS THAN ('300'));

show create table [partition];

drop table if exists [partition];

--example03
drop table if exists [partition];

CREATE TABLE [partition](id integer AUTO_INCREMENT(1,1) NOT NULL,
ch character(10) COLLATE iso88591_bin ,
CONSTRAINT pk PRIMARY KEY(id,ch)
) COLLATE iso88591_bin ;

ALTER TABLE [partition] PARTITION BY RANGE ([[ch]]) (PARTITION p1 VALUES LESS THAN ('100'), PARTITION p2 VALUES LESS THAN ('200'), PARTITION p3 VALUES LESS THAN ('300'));

show create table [partition];

drop table if exists [partition];

--+ holdcas off;
commit;
