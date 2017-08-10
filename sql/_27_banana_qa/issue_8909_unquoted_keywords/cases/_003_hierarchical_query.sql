--test RW column used in hierarchical query

CREATE TABLE tree("last" INT, "return" INT, "user" VARCHAR(32), "year" INT);

INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);

-- Executing a hierarchical query with CONNECT BY clause
SELECT tt.last, tt.return, tt.user
FROM tree tt
CONNECT BY PRIOR tt.last=tt.return
ORDER BY tt.last;


SELECT tt.last, tt.return, tt.user
FROM tree tt
START WITH tt.return IS NULL
CONNECT BY prior tt.last=tt.return
ORDER BY tt.last;


drop table tree;
