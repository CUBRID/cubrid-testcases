DROP TABLE IF EXISTS o_l;
CREATE TABLE o_l
( 
  o_n VARCHAR(10) NOT NULL
 ,l_o VARCHAR(10) NOT NULL 
 ,TYPE VARCHAR(10) NOT NULL 
);

DELETE FROM o_l;
 
INSERT INTO o_l VALUES ('A', 'C', 'refers');
INSERT INTO o_l VALUES ('A', 'B', 'refers');
INSERT INTO o_l VALUES ('B', 'E', 'refers');
INSERT INTO o_l VALUES ('C', 'H', 'refers');
INSERT INTO o_l VALUES ('H', 'I', 'refers');
INSERT INTO o_l VALUES ('I', 'D', 'refers');
INSERT INTO o_l VALUES ('D', 'F', 'refers');
INSERT INTO o_l VALUES ('D', 'C', 'refers');
INSERT INTO o_l VALUES ('F', 'J', 'refers');
INSERT INTO o_l VALUES ('J', 'K', 'refers');
INSERT INTO o_l VALUES ('J', 'G', 'refers');
INSERT INTO o_l VALUES ('K', 'L', 'refers');
INSERT INTO o_l VALUES ('F', 'L', 'refers');
INSERT INTO o_l VALUES ('K', 'M', 'refers');
 

SELECT connect_by_root o_n, level, o_n,TYPE,   l_o
FROM "o_l"
connect BY nocycle o_n = prior l_o
START WITH o_n = 'A'
order by 1,2,3,4,5;


SELECT connect_by_root o_n, level, TYPE, o_n, l_o
FROM "o_l"
connect BY o_n = prior l_o
START WITH o_n = 'A'
order by 1,2,3,4,5;


DROP TABLE IF EXISTS o_l;
