--test 'drop ... cascade constraints' with prepared statement

CREATE TABLE a_parent ( id INTEGER PRIMARY KEY,  name VARCHAR(10));

CREATE TABLE b_child1 ( id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id1 FOREIGN KEY(parent_id) REFERENCES a_parent(id));
CREATE TABLE b_child2 ( id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id2 FOREIGN KEY(parent_id) REFERENCES a_parent(id));
CREATE TABLE b_child3 ( id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id3 FOREIGN KEY(parent_id) REFERENCES a_parent(id));

insert into a_parent values (1,'aaa');
insert into b_child1 values (10,1), (11,1), (12, 1);
insert into b_child2 values (20,1), (21,1), (22, 1);
insert into b_child3 values (30,1), (31,1), (32, 1);

--test: with prepared statement
prepare st from 'drop table if exists a_parent cascade constraints;';
execute st;
deallocate prepare st;

desc b_child1;
desc b_child2;
desc b_child3;
select * from b_child3 order by 1;

drop table b_child1, b_child2, b_child3;

