--test fk referential action: on delete set null

CREATE TABLE a_tbl (
  id INT NOT NULL DEFAULT 0 PRIMARY KEY,
  phone VARCHAR(10)
);

CREATE TABLE b_tbl (
  ID INT,
  name VARCHAR (10) NOT NULL,
  CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES a_tbl (id)
  ON DELETE SET NULL
);

INSERT INTO a_tbl VALUES (1,'111-1111'), (2,'222-2222'), (3, '333-3333');
INSERT INTO b_tbl VALUES (1,'George'),(2,'Laura'), (3,'Max');


--test: drop table on cascade
DROP a_tbl CASCADE CONSTRAINTS;

show index from b_tbl;
SELECT * FROM b_tbl ORDER BY 1;


DROP TABLE b_tbl;
