drop table if exists foo,doc_t;
CREATE TABLE doc_t (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
INSERT INTO doc_t VALUES ('doc-10', CHAR_TO_CLOB('This is content'));
INSERT INTO doc_t VALUES ('doc-11', CHAR_TO_CLOB ('This is content 3'));

SELECT doc_id, CLOB_TO_CHAR(content) FROM doc_t ;


 WITH cars AS(
 SELECT CLOB_TO_CHAR(content) FROM doc_t WHERE doc_id = 'doc-11' 
 ) DELETE doc_t from doc_t,cars WHERE doc_t.content=(SELECT content FROM cars);
 
 SELECT doc_id, CLOB_TO_CHAR(content) FROM doc_t ;
 
 WITH cars AS(
 SELECT content FROM doc_t WHERE doc_id = 'doc-11' 
 ) DELETE doc_t from doc_t,cars WHERE CLOB_TO_CHAR(doc_t.content)=(SELECT CLOB_TO_CHAR(content) FROM cars);

-- system crash occurred and then restart server
SELECT doc_id, CLOB_TO_CHAR(content) FROM doc_t ;

drop table if exists foo,doc_t;
