--+ holdcas on;
-- test drop foreign key when table has reference
create table foo (id int, name varchar(200), primary key (id));
create table bar (id int, name varchar(200), c int not null, constraint foreign key (id) references foo(id));
create table bar01 under bar (a int, b int);
create table bar02 under bar (a int, b int);
alter table bar drop constraint fk_bar_id;

drop table bar02;
drop table bar01;
drop table bar;
drop table foo;
commit;

-- test drop primary key when table has partition
CREATE TABLE bar (id int, name VARCHAR(200), PRIMARY KEY(id)) PARTITION BY RANGE(id) (PARTITION aa VALUES LESS THAN(2000), partition bbb VALUES LESS THAN MAXVALUE); 
ALTER TABLE bar DROP CONSTRAINT pk_bar_id; 
ALTER TABLE bar ADD CONSTRAINT PRIMARY KEY(name, id); 

drop table bar;
commit;

--test primary key when table has sub table
create table bar (id int, name varchar(200), primary key(id));
create table bar01 under bar (a int, b int);
create table bar02 under bar (a int, b int);
alter table bar drop constraint pk_bar_id;
alter table bar add constraint primary key(name, id);

drop table bar;
drop table bar01;
drop table bar02;
commit;


--+ holdcas off;
