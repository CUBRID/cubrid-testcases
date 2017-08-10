
--+ holdcas on;

drop table if exists t1;
CREATE TABLE t1 (c1 INT PRIMARY KEY AUTO_INCREMENT);
INSERT INTO t1 VALUES (NULL);
INSERT INTO t1 VALUES (NULL);
-- rename AUTO_INCREMENT column
ALTER TABLE t1 CHANGE c1 d1 INT NOT NULL AUTO_INCREMENT;
--continue to insert
INSERT INTO t1 VALUES (NULL);
--you will find unique constraint violations occure. But MySQL works well.
select * from t1 order by 1;

drop table if exists t1;

--+ holdcas off;
commit;
