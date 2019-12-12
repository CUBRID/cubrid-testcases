drop if exists a_tbl;
CREATE TABLE a_tbl(A INT AUTO_INCREMENT(3,10) PRIMARY KEY,b timestamp default current_timestamp on update current_timestamp);
INSERT INTO a_tbl(a) VALUES (NULL),(NULL),(NULL);
update a_tbl set a=a+20;
TRUNCATE TABLE a_tbl;
SELECT * FROM a_tbl;
INSERT INTO a_tbl(a) VALUES (NULL);
select sleep(5);
update a_tbl set a=a+20;
SELECT if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') FROM a_tbl;
drop if exists a_tbl;



