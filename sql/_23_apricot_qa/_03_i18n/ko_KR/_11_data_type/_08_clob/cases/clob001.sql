--+ holdcas on;
set names utf8;
CREATE TABLE doc_t (doc_id VARCHAR(64)  collate utf8_ko_cs_uca PRIMARY KEY, content CLOB);
ALTER TABLE doc_t ADD CONSTRAINT content_unique UNIQUE(content);
CREATE INDEX idx ON doc_t (content);
CREATE TABLE image_t (image_id VARCHAR(36)  collate utf8_ko_cs_uca PRIMARY KEY, doc_id VARCHAR(64)  collate utf8_ko_cs_uca NOT NULL, image BLOB);
ALTER TABLE image_t ADD COLUMN thumbnail BLOB NOT NULL;
ALTER TABLE image_t ADD COLUMN thumbnail2 BLOB DEFAULT BIT_TO_BLOB(X'010101');
INSERT INTO doc_t (doc_id, content) VALUES ('문서-1', CHAR_TO_CLOB('이것은 개입니다'));
INSERT INTO doc_t (doc_id, content) VALUES ('문서-2', CHAR_TO_CLOB('이것은 고양이'));
INSERT INTO image_t VALUES ('이미지-0', '문서-0', BIT_TO_BLOB(X'000001'));
INSERT INTO image_t VALUES ('이미지-1', '문서-1', BIT_TO_BLOB(X'000010'));
INSERT INTO image_t VALUES ('이미지-2', '문서-2', BIT_TO_BLOB(X'000100'));
INSERT INTO image_t SELECT '이미지-1010', '문서-1010', image FROM image_t WHERE image_id = '이미지-0';
UPDATE doc_t SET content = NULL WHERE doc_id = '문서-1';
UPDATE doc_t SET content = CHAR_TO_CLOB('이것은 개입니다') WHERE doc_id = '문서-1';
UPDATE image_t SET image = (SELECT image FROM image_t WHERE image_id = '이미지-0') WHERE image_id = '이미지-1';
DELETE FROM image_t WHERE image_id = '이미지-1010';
SELECT doc_t.doc_id, CLOB_TO_CHAR(content), BLOB_TO_BIT(image) FROM doc_t, image_t WHERE doc_t.doc_id = image_t.doc_id order by 1,2,3;
SELECT CLOB_TO_CHAR(content), SUBSTRING(CLOB_TO_CHAR(content), 5) FROM doc_t order by 1,2;
SELECT CLOB_TO_CHAR(content) FROM doc_t WHERE CLOB_TO_CHAR(content) LIKE '%개%' order by 1;
SELECT CLOB_TO_CHAR(content) FROM doc_t ORDER BY CLOB_TO_CHAR(content)

SELECT CLOB_TO_CHAR(content) FROM doc_t WHERE content LIKE '이%' order by 1;
SELECT * FROM doc_t ORDER BY content;
drop table doc_t,image_t;
set names iso88591;
commit;
--+ holdcas off;
