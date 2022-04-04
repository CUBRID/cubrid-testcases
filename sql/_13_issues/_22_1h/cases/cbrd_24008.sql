DROP TABLE IF EXISTS tbl_a;
DROP TABLE IF EXISTS tbl_b;

CREATE TABLE tbl_a
  (
     id VARCHAR(10)
  );
CREATE TABLE tbl_b
  (
     id   VARCHAR(10),
     vote INT
  );
CREATE INDEX idx ON tbl_b(id);
INSERT INTO tbl_a
VALUES      ('2'),
            ('1');
INSERT INTO tbl_b
VALUES      ('1','1');
SELECT /*+ recompile */ (SELECT Nvl(Sum(vote), 0)
                         FROM   tbl_b
                         WHERE  tbl_b.id LIKE Substr(tbl_a.id, 1, 3)
                                             || '%')
FROM   tbl_a;
DROP TABLE tbl_a;
DROP TABLE tbl_b;
