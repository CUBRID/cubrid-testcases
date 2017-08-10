drop table if exists a_parent;
drop table if exists b_child;

CREATE TABLE a_parent ( id INTEGER PRIMARY KEY,  name VARCHAR(10));
CREATE TABLE b_child ( id INTEGER, parent_id INTEGER,
    CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent(id));
insert into a_parent values (1,'aaa');
insert into b_child values (10,1), (11,1), (12, 1);

drop table a_parent cascade constraints;

drop table if exists a_parent;
drop table if exists b_child;
