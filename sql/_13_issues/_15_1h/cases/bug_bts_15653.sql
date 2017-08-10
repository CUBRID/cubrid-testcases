drop table if exists main_table;
CREATE TABLE main_table(id INT primary key);
CREATE TABLE fk_table(id INT, FOREIGN KEY (id) REFERENCES main_table(id));
drop table if exists fk_table;
drop table if exists main_table;
