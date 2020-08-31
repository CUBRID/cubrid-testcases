--+ holdcas on;

set names utf8;
drop class if exists t1;
create class t1(
col1 string collate binary, 
col2 char(10) collate utf8_ja_exp , 
col3 varchar(10) collate utf8_ja_exp , 
col4 DATE,
col5 TIME,
col6 TIMESTAMP,
col7 SET,
col8 MULTISET,
col9 SEQUENCE );
INSERT INTO t1 VALUES ('ヨあ12p■「亜','ヨあ12p■「亜','ヨあ12p■「亜','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00',{'ヨあ12p■「亜'},{'ヨあ12p■「亜'},{'ヨあ12p■「亜'});
INSERT INTO t1 VALUES ('亜唖娃阿哀愛挨姶',null,'亜唖娃阿哀愛挨姶','2008-06-28', '10:24:00', '2008-05-26 10:25:00',{'亜唖娃阿哀愛挨姶'},{'亜唖娃阿哀愛挨姶'},{'亜唖娃阿哀愛挨姶'});
INSERT INTO t1 VALUES ('ゞ ゝヽ ヾ ぁァ あア','ゞ ゝヽ ヾ ぁァ ','ゞ ゝヽ ヾ ぁァ ','2008-05-26', '14:23:00', '2008-06-28 14:24:00',{'ゞ ゝヽ ヾ ぁァ あア'},{'ゞ ゝヽ ヾ ぁァ あア'},{'ゞ ゝヽ ヾ ぁァ あア'});
INSERT INTO t1 VALUES (null,'せぜそぞただちぢ','せぜそぞただちぢ','2009-05-26', '14:16:19', ' 2008-05-26 14:24:00',null,{'せぜそぞただちぢ'},null);
INSERT INTO t1 VALUES ('せぜそぞただちぢ',null,null,'2008-05-28', '14:24:01', '2008-05-26 14:24:01',{'せぜそぞただちぢ'},null,{'せぜそぞただちぢ'});

create index t1_index on t1(col8);
--test
SELECT * FROM t1 order by 1,2;
--test
SELECT col8 FROM t1 order by col8;

UPDATE t1 SET col8={'ヨあ12p■「亜_aa'} WHERE col1='ヨあ12p■「亜';

DELETE  FROM t1 WHERE col1='ヨあ12p■「亜';
--test
SELECT * FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT col8 FROM t1 order by col8;

drop class t1;
set names iso88591;

commit;
--+ holdcas off;

