--dev case 6, drop partition (do not allow)

CREATE TABLE a_parent ( id INTEGER PRIMARY KEY,  name VARCHAR(10)) 
PARTITION BY range(id) 
(PARTITION before_2 VALUES LESS THAN (2),
PARTITION before_2000 VALUES LESS THAN (2000));
CREATE TABLE b_child ( id INTEGER, parent_id INTEGER,
CONSTRAINT fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent(id));

insert into a_parent values (1,'aaa'), (2, 'bbb'), (3, 'ccc');
insert into b_child values (10,1), (11,1), (12, 1);

ALTER TABLE  a_parent DROP PARTITION before_2;

drop table a_parent cascade constraints;

select * from b_child order by 1;

drop table b_child;
