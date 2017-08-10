drop table if exists tab0;
CREATE TABLE tab0(pk INTEGER, col0 INTEGER );
INSERT INTO tab0 VALUES(1,1);
SELECT 21 FROM tab0 WHERE not - col0 = - col0;
drop table tab0;
