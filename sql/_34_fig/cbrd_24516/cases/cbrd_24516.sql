-- This test case verify the CBRD-24516.
-- The trace information which is prited from "show trace" did not print the aggregate optimization-related information.
-- After enhance when the aggregate optimization is enable it should be printed from "show trace".


DROP TABLE IF EXISTS tbl; 

CREATE TABLE tbl (id INTEGER not null primary key , phone VARCHAR(20));
INSERT INTO tbl VALUES (1, '123-456-789');
INSERT INTO tbl VALUES (999, '999-999-999');

SET TRACE ON;

-- case 1: optimized-scan
SELECT COUNT(*) FROM tbl;
SHOW TRACE;

SELECT MAX(id) FROM tbl;
SHOW TRACE;

SELECT MIN(id) FROM tbl;
SHOW TRACE;

-- case 2: for not-optimized-scan
SELECT COUNT(*) FROM tbl WHERE id > 1;
SHOW TRACE;

SELECT MAX(phone) FROM tbl;
SHOW TRACE;

SELECT MIN(phone) FROM tbl;
SHOW TRACE;

SET TRACE OFF;

DROP TABLE IF EXISTS tbl; 
