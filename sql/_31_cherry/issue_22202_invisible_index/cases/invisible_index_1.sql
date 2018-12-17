drop table if exists a_tbl , b_tbl ;

CREATE TABLE a_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
);

CREATE TABLE b_tbl (
    id INT NOT NULL,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT pk_id PRIMARY KEY (id),
    CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES a_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
);

INSERT INTO a_tbl VALUES (1,'111-1111'), (2,'222-2222'), (3, '333-3333');
INSERT INTO b_tbl VALUES (1,'George'),(2,'Laura'), (3,'Max');

--@queryplan
SELECT a.id, b.id, a.phone, b.name FROM a_tbl a, b_tbl b WHERE a.id = b.id order by 1;

show index from a_tbl;
show index from b_tbl;

alter index pk_a_tbl_id on a_tbl invisible;
alter index pk_id on b_tbl invisible;         
alter index fk_id on b_tbl invisible; 

--@queryplan
SELECT a.id, b.id, a.phone, b.name FROM a_tbl a, b_tbl b WHERE a.id = b.id order by 1;

drop table if exists b_tbl, a_tbl ;

drop table if exists const_tbl1, const_tbl2;
CREATE TABLE const_tbl1(id INT NOT NULL, INDEX i_index(id ASC), phone VARCHAR);
CREATE TABLE const_tbl2(id INT NOT NULL PRIMARY KEY, phone VARCHAR);
alter index i_index on const_tbl1 invisible;
drop table if exists const_tbl1, const_tbl2;


