--test fk referential action: on delete cascade

CREATE TABLE a_tbl (
  id INT NOT NULL DEFAULT 0 PRIMARY KEY,
  phone VARCHAR(10)
);

CREATE TABLE b_tbl (
  ID INT NOT NULL,
  name VARCHAR (10) NOT NULL,
  CONSTRAINT pk_id PRIMARY KEY (id),
  CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES a_tbl (id)
  ON DELETE CASCADE ON UPDATE RESTRICT
);

INSERT INTO a_tbl VALUES (1,'111-1111'), (2,'222-2222'), (3, '333-3333');
INSERT INTO b_tbl VALUES (1,'George'),(2,'Laura'), (3,'Max');


--test: drop table on cascade
DROP a_tbl CASCADE CONSTRAINTS;

SELECT * FROM b_tbl ORDER BY 1;


DROP TABLE b_tbl;
