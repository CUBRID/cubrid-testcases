--
drop table if exists fk20,pk20,pk_super10;
create table pk_super10 (id int primary key);
create table pk20 under pk_super10 ( a int);
create table fk20 (id int);
 
alter table fk20 add constraint foreign key (id) references pk20(id) on delete cascade;
insert into pk20 values (1,1),(2,2),(3,3);
insert into fk20 values (1), (1), (1);
 
delete from pk20;
 
select count(*) from pk20; 
select count(*) from fk20; 
drop table if exists fk20,pk20,pk_super10;

--

drop table if exists fk20,pk20,pk_super10;
create table pk_super10 (id int primary key);
create table pk20 under pk_super10 ( a int);
create table fk20 (id int);
 
alter table fk20 add constraint foreign key (id) references pk20(id) on delete cascade;
insert into pk20 values (1,1),(2,2),(3,3);
insert into fk20 values (1), (1), (1);
 
delete from pk20 where a=1;
 
select * from pk20; 
select * from fk20; 
drop table if exists fk20,pk20,pk_super10;


drop table if exists fk20,pk20,pk_super10;
create table pk_super10 (id int primary key); 
create table pk20 under pk_super10 ( a int); 

create table fk20 (id int); 
alter table fk20 add constraint foreign key (id) references pk20(id) on delete cascade; 
insert into pk20 values (1,1),(2,2),(3,3); 
insert into fk20 values (1), (1), (2); 

ALTER TABLE fk20 DROP CONSTRAINT fk_fk20_id; 
ALTER TABLE pk20 ADD COLUMN c int; 


delete from pk20 WHERE a = 1 or a =2; 
SELECT * from pk20; 
SELECT * from fk20; 

drop table if exists fk20,pk20,pk_super10;
