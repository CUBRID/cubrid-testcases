drop table if exists t1,t2,t3;


CREATE TABLE t1 (trackid int (10) NOT NULL, trackname varchar (100) NOT NULL);
CREATE TABLE t2 (artistid int (10) NOT NULL, artistname varchar (100) NOT NULL);
CREATE TABLE t3 (trackid int (10) NOT NULL, artistid int (10) NOT NULL);
INSERT INTO t1 VALUES (1, 'April In Paris'), (2, 'Autumn In New York');
INSERT INTO t2 VALUES (1, 'Vernon Duke');
INSERT INTO t3 VALUES (1, 1);
--below query show 2 rows. It's the same with MySQL. This is good.
SELECT case when ((CONCAT_WS(' ', trackname, artistname) like '%In%') = 1) then 'OK' else 'NOK' end result FROM t1 LEFT JOIN t3 ON t1.trackid = t3.trackid LEFT JOIN t2 ON t2.artistid = t3.artistid;
--As for below sql, according to above result, we expect 2 rows list in result.
SELECT * FROM  t1 LEFT JOIN t3 ON t1.trackid = t3.trackid LEFT JOIN t2 ON t2.artistid = t3.artistid WHERE CONCAT_WS(' ', trackname, artistname) like '%In%' order by 1;

SELECT /*+ recompile */ *,length(t2.artistid) FROM  
t1 LEFT JOIN t2 
ON t1.trackid = t2.artistid 
WHERE  length(t2.artistid) >= 0 order by 1;

drop table t1,t2,t3;
