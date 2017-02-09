drop table if exists fk_test2, fk_test1;
CREATE TABLE fk_test1 (col1 VARCHAR(10), col2 VARCHAR(10), col3 VARCHAR(10), col4 VARCHAR(10)); 
CREATE TABLE fk_test2 (code INT AUTO_INCREMENT PRIMARY KEY, col1 VARCHAR(10), col2 VARCHAR(10)); 

ALTER TABLE fk_test1 ADD CONSTRAINT pk_fk_test1 PRIMARY KEY (col1,col2); 
ALTER TABLE fk_test2 ADD CONSTRAINT fk_test1_fk FOREIGN KEY (col1,col2) REFERENCES fk_test1(col1,col2); 

INSERT INTO fk_test1(col1, col2) VALUES ('aa','bb'); 
INSERT INTO fk_test2(col1, col2) VALUES (NULL,null); 
INSERT INTO fk_test2(col1, col2) VALUES ('aa',null); 
INSERT INTO fk_test2(col1, col2) VALUES (NULL,'bb'); 

ALTER TABLE fk_test2 DROP CONSTRAINT fk_test1_fk; 
ALTER TABLE fk_test2 ADD CONSTRAINT fk_test1_fk FOREIGN KEY (col1,col2) REFERENCES fk_test1(col1,col2); 


---- FK of this case shares the existing index, "i".
drop table if exists fk_test2, fk_test1;
CREATE TABLE fk_test1 (col1 VARCHAR(10), col2 VARCHAR(10), col3 VARCHAR(10), col4 VARCHAR(10));
CREATE TABLE fk_test2 (code INT AUTO_INCREMENT PRIMARY KEY, col1 VARCHAR(10), col2 VARCHAR(10));

ALTER TABLE fk_test1 ADD CONSTRAINT pk_fk_test1 PRIMARY KEY (col1,col2);
create index i on fk_test2 (col1, col2);

INSERT INTO fk_test1(col1, col2) VALUES ('aa','bb');
INSERT INTO fk_test2(col1, col2) VALUES (NULL,null);
INSERT INTO fk_test2(col1, col2) VALUES ('aa',null);
INSERT INTO fk_test2(col1, col2) VALUES (NULL,'bb');

ALTER TABLE fk_test2 ADD CONSTRAINT fk_test1_fk_another FOREIGN KEY (col1,col2) REFERENCES fk_test1(col1,col2);
drop table if exists fk_test2, fk_test1;
