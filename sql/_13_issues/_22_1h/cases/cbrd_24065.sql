CREATE TABLE [tbl] (
  part_id CHARACTER VARYING (1073741823),
  INDEX idx (NVL(part_id, NULL)),
  INDEX idx1 (SUBSTR(part_id, 2))
) ;

SELECT * FROM tbl 
WHERE NVL(part_id, null) in ( SELECT '1') ;

DROP TABLE [tbl];
