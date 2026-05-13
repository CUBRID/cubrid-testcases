-- ============================================================================
-- CBRD-26276 - Circular FK references and DROP PK on FK-referenced column tests (single mode)
-- ha mode : HA/shell/_40_guava/cbrd_26096/cbrd_26276/cases/cbrd_26276.sh
-- ============================================================================
drop table if exists circle_b_tbl;
drop table if exists circle_a_tbl;

-- Circular FK Schema creation
CREATE TABLE circle_a_tbl (
    a_id   INT PRIMARY KEY,
    b_id   INT,
    a_name VARCHAR(20)
)replication on;

CREATE TABLE circle_b_tbl (
    b_id   INT PRIMARY KEY,
    a_id   INT,
    b_name VARCHAR(20),
    CONSTRAINT fk_circle_b_tbl_a
        FOREIGN KEY (a_id) REFERENCES circle_a_tbl (a_id)
        ON DELETE CASCADE ON UPDATE RESTRICT
)replication on;

ALTER TABLE circle_a_tbl
    ADD CONSTRAINT fk_circle_a_tbl_b
    FOREIGN KEY (b_id) REFERENCES circle_b_tbl (b_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Verify schema: check constraints exist
evaluate '1. circular_fk_schema';
SELECT class_name, index_name FROM db_index 
WHERE class_name IN ('circle_a_tbl', 'circle_b_tbl') 
ORDER BY class_name, index_name;

-- Data insertion with NULL to avoid FK conflict, then UPDATE
INSERT INTO circle_a_tbl (a_id, b_id, a_name) VALUES (1, NULL, 'A1');
INSERT INTO circle_b_tbl (b_id, a_id, b_name) VALUES (10, NULL, 'B10');
UPDATE circle_b_tbl SET a_id = 1  WHERE b_id = 10;
UPDATE circle_a_tbl SET b_id = 10 WHERE a_id = 1;

-- Verify data: circular reference established (a_id=1 <-> b_id=10)
evaluate '2. circular_fk_data';
SELECT a.a_id, a.a_name, a.b_id, b.b_id AS b_b_id, b.b_name, b.a_id AS b_a_id
FROM circle_a_tbl a
JOIN circle_b_tbl b ON a.b_id = b.b_id AND b.a_id = a.a_id
ORDER BY a.a_id;

-- 3: DROP PK on circle_a_tbl (referenced by fk_circle_b_tbl_a) -> error
evaluate '3. drop_pk_fk_ref_a';
ALTER TABLE circle_a_tbl DROP PRIMARY KEY;

-- 4: DROP PK on circle_b_tbl (referenced by fk_circle_a_tbl_b) -> error
evaluate '4. drop_pk_fk_ref_b';
ALTER TABLE circle_b_tbl DROP PRIMARY KEY;

-- DROP FK constraints
ALTER TABLE circle_a_tbl DROP CONSTRAINT fk_circle_a_tbl_b;
ALTER TABLE circle_b_tbl DROP CONSTRAINT fk_circle_b_tbl_a;

drop table if exists circle_b_tbl;
drop table if exists circle_a_tbl;

