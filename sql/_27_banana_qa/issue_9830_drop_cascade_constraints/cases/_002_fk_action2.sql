--test fk referential action: on delete restrict, composed pk

CREATE TABLE a_tbl (
  id INT NOT NULL DEFAULT 0,
  name VARCHAR(20) NOT NULL,
  phone VARCHAR(10),
  CONSTRAINT pk_idx PRIMARY KEY(id, name)
);

CREATE TABLE b_tbl (
  ID INT NOT NULL,
  name VARCHAR (10) NOT NULL,
  CONSTRAINT pk_idx PRIMARY KEY (id),
  CONSTRAINT fk_idx FOREIGN KEY (id, name) REFERENCES a_tbl (id, name)
  ON DELETE RESTRICT ON UPDATE RESTRICT
);

INSERT INTO a_tbl VALUES (1,'George', '111-1111'), (2,'Laura', '222-2222'), (3, 'Max', '333-3333'), (4, 'Mike', '444-4444');
INSERT INTO b_tbl VALUES (1,'George'),(2,'Laura'), (3,'Max');


--test: drop table on cascade
DROP a_tbl CASCADE CONSTRAINTS;

update statistics on all classes;
show index from b_tbl;
SELECT * FROM b_tbl ORDER BY 1;


DROP TABLE b_tbl;
