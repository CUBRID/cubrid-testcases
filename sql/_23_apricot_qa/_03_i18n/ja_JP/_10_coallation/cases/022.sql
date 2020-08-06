--+ holdcas on;

set names utf8;
drop class if exists t1;
create class t1(
col1 string collate binary, 
col2 char(10) collate utf8_ja_exp , 
col3 varchar(10) collate utf8_ja_exp , 
col4 DATE,
col5 TIME,
col6 TIMESTAMP );
INSERT INTO t1 VALUES ('ヨあ12p■「亜','ヨあ12p■「亜','ヨあ12p■「亜','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('亜唖娃阿哀愛挨姶',null,'亜唖娃阿哀愛挨姶','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('ゞ ゝヽ ヾ ぁァ あア','ゞ ゝヽ ヾ ぁァ ','ゞ ゝヽ ヾ ぁァ ','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES (null,'亜唖娃阿哀愛挨姶啊你','せぜそぞただちぢ','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('せぜそぞただちぢ',null,null,'2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');

create Reverse unique index t1_index on t1(col2) where col1>='ヨあ12p■「亜';
--test
SELECT * FROM t1 where col1>='ヨあ12p■「亜' order by 1,2;
--test
SELECT col2 FROM t1 where col1>='ヨあ12p■「亜' order by col2;

UPDATE t1 SET col2='おかがきぎくぐ' WHERE col2='ゞ ゝヽ ヾ ぁァ あア';

DELETE  FROM t1 WHERE col2='亜唖娃阿哀愛挨姶啊你';
--test
SELECT * FROM db_index WHERE class_name='t1'  order by 1,2;
--test
SELECT col2 FROM t1 where col1>='ヨあ12p■「亜' order by col2;

drop class t1;
set names iso88591;

commit;
--+ holdcas off;

