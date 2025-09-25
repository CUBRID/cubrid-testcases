-- Cleanup
DROP TRIGGER IF EXISTS trg_a;
DROP TABLE IF EXISTS tbl_a;

-- Create table with recursion control
CREATE TABLE tbl_a(col_a INT, col_b INT, depth INT DEFAULT 1);

-- Trigger with depth check
CREATE TRIGGER trg_a
DEFERRED INSERT ON tbl_a
IF NEW.depth < 32
EXECUTE INSERT INTO tbl_a(col_a, col_b, depth) VALUES (1, 2, NEW.depth + 1);

-- Trigger the recursion
INSERT INTO tbl_a(col_a, col_b) VALUES (1, 1);

-- Cleanup
-- Drop the trigger first (so no deferred actions reference it anymore)
DROP TRIGGER IF EXISTS trg_a;

-- Then drop the table safely
DROP TABLE IF EXISTS tbl_a;

