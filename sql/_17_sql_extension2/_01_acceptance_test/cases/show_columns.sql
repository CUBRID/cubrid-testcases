--show columns

CREATE TABLE soo (a int PRIMARY KEY AUTO_INCREMENT, b char(20), c char(3) NOT NULL, d int DEFAULT 10);

SHOW COLUMNS FROM soo;

DROP TABLE soo;
