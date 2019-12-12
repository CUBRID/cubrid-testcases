drop if exists a_tbl, new_tbl, new_tbl_1;

CREATE TABLE a_tbl (
  id INT NOT NULL DEFAULT 0 PRIMARY KEY,
  phone VARCHAR(10)
);
INSERT INTO a_tbl VALUES (1,'111-1111'), (2,'222-2222'), (3, '333-3333');
CREATE index idx1 on a_tbl(id desc) invisible;

show create table a_tbl;
show index from a_tbl;
select * from a_tbl order by 1;

CREATE TABLE new_tbl LIKE a_tbl;
show create table  new_tbl;
show index from new_tbl;
select * from new_tbl order by 1;

CREATE TABLE new_tbl_1 as select * from a_tbl using index pk_a_tbl_id;
show create table new_tbl_1;
show index from new_tbl_1;
select * from new_tbl_1 order by 1;

drop if exists a_tbl, new_tbl, new_tbl_1;

