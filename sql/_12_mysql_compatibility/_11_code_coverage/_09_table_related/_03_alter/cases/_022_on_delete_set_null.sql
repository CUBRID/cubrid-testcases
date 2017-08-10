create table tbl_1 (id int primary key);
create table tbl_2 (id int not null);
alter table tbl_2 add constraint foreign key (id) references tbl_1(id) on delete set null;

drop table tbl_2;
drop table tbl_1;


CREATE TABLE parent (id INT, PRIMARY KEY (id));
CREATE TABLE child_3 (id INT, PRIMARY KEY (id), parent_id INT NOT NULL) partition by range (id) (partition p0 values less than (100), partition p1 values less than MAXVALUE);
ALTER TABLE child_3 ADD CONSTRAINT FOREIGN KEY (parent_id) REFERENCES parent(id) ON DELETE SET NULL;

drop table child_3;
drop table parent;



CREATE TABLE parent (id INT, PRIMARY KEY (id));
CREATE TABLE child_3 (id INT, PRIMARY KEY (id), parent_id INT);
ALTER TABLE child_3 ADD CONSTRAINT FOREIGN KEY (parent_id) REFERENCES parent(id) ON DELETE SET NULL;
ALTER TABLE child_3 partition by range (id) (partition p0 values less than (100), partition p1 values less than MAXVALUE);

drop table child_3;
drop table parent;
