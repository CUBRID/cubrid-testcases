DROP TABLE IF EXISTS o_l;
CREATE TABLE o_l
( 
  o_n VARCHAR(10) NOT NULL
 ,l_o VARCHAR(10) NOT NULL 
 ,TYPE VARCHAR(10) NOT NULL 
);

DELETE FROM o_l;
 
INSERT INTO o_l VALUES ('A', 'B', 'refers');
INSERT INTO o_l VALUES ('B', 'C', 'refers');
INSERT INTO o_l VALUES ('C', 'D', 'refers');
INSERT INTO o_l VALUES ('D', 'A', 'refers');
 

SELECT connect_by_root o_n, level, o_n,TYPE,   l_o
FROM "o_l"
connect BY nocycle o_n = prior l_o
START WITH o_n = 'A';


SELECT connect_by_root o_n, level, TYPE, o_n, l_o
FROM "o_l"
connect BY o_n = prior l_o
START WITH o_n = 'A';


DROP TABLE IF EXISTS o_l;
