--alter table change/modify column

CREATE TABLE xoo (a int, b char(10));

INSERT INTO xoo VALUES (1, 'HELLO'), (2, 'KITTY');

SHOW COLUMNS IN xoo;

ALTER TABLE xoo CHANGE a a int not null;
SHOW COLUMNS IN xoo;

ALTER TABLE xoo CHANGE a c char(20);
SHOW COLUMNS IN xoo;
SELECT * FROM xoo ORDER BY 1;

ALTER TABLE xoo MODIFY b int NOT NULL;
SHOW COLUMNS IN xoo;
SELECT * FROM xoo ORDER BY 1;

DROP TABLE xoo;

