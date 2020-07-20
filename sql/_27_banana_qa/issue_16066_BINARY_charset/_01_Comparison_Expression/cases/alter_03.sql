--+ holdcas on;
-- partition table
set names binary;
drop table if exists range_test;
create table range_test(id int,test_string string collate binary, primary key(id, test_string));
insert into range_test values(1,'àà');
insert into range_test values(2,'èè');
alter table range_test PARTITION BY RANGE (test_string) (               
	PARTITION p0 VALUES LESS THAN ('ìì') 
); 
select * from range_test order by id;
drop table range_test;

-- primary/foreign key
set names utf8;
drop table if exists album;
drop table if exists track;
CREATE TABLE album(
  id CHAR(10),
  title VARCHAR(30) collate binary,
  song VARCHAR(20) collate euckr_bin
);
CREATE TABLE track(
  album CHAR(10),  
  title VARCHAR(30) collate binary,
  dsk VARCHAR(10) collate utf8_bin,
  song VARCHAR(20) collate euckr_bin
);
--insert into album values('1','문자열문자열문자열','열문자열');
--insert into track values('1','문자열문자열문자열','ÀÏÀÏÀÏÀÏ', '열문자열');
insert into album values('1','문자열문자열문자열','열문자열');
insert into track values('1','문자열문자열문자열','ÀÏÀÏÀÏÀÏ', '열문자열');

alter table album add constraint pk_album primary key (title,song);
ALTER TABLE track ADD ATTRIBUTE CONSTRAINT "fk_track_album"  FOREIGN KEY (title,song) REFERENCES album(title,song);
select * from track order by 1,2,3,4;
select * from album order by 1,2,3;
select * from db_index where class_name in ('album', 'track') order by 1;
select * from db_index_key where class_name in ('album','track') order by 2,1;
select * from db_attribute where class_name in ('album','track') order by 2,1;
drop table track;
drop table album;

--default value
set names utf8;
drop table if exists t1;
create table t1 (col_binary char(30) collate binary default '문자열문자열문자열' , col_euckr varchar(30) collate euckr_bin default '문자열문자열문자열' , col_utf8 varchar(30) collate utf8_bin, col_iso varchar(30) collate iso88591_bin);
insert into t1(col_utf8,col_iso) values('문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
select * from t1 order by 1;

set names binary;
alter table t1 alter column col_binary set default '안녕하세요';
alter table t1 alter column col_euckr set default cast(_utf8'안녕하세요' as string charset euckr);
insert into t1(col_utf8,col_iso) values('안녕하세요', 'êüò');
select * from t1 order by 1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;
