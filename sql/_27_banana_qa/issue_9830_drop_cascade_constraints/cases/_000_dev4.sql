--dev case 4, drop self reference fk


CREATE TABLE a_parent ( id INTEGER primary key, parent_id INTEGER,
CONSTRAINT fk_parent_id2 FOREIGN KEY(parent_id) REFERENCES a_parent(id));
insert into a_parent values (1,1), (2,2), (3, 1);

show index from a_parent;

drop table a_parent cascade constraints;
