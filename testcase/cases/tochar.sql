drop table if exists foo,doc_t;
CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
INSERT INTO doc_t VALUES ('doc-10', CHAR_TO_CLOB('This is content'));
INSERT INTO doc_t VALUES ('doc-11', CHAR_TO_CLOB ('This is content 3'));

UPDATE doc_t SET content = 
(WITH cars (content)AS(SELECT content FROM doc_t WHERE doc_id = 'doc-11')
SELECT content FROM cars )
WHERE doc_id = 'doc-10';

-- system crash occurred and then restart server
SELECT doc_id, CLOB_TO_CHAR(content) FROM doc_t WHERE doc_id = 'doc-10';

drop table if exists foo,doc_t;
