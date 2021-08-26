autocommit off;
create table x(a int primary key); 
create table t1 (a int primary key, b int unique, c int not null, d int, e int, f int, g int, h int, i char(10));
create index idx1 on t1(d desc, e, f desc);
create reverse index idx2 on t1(e);
create unique index idx3 on t1(f, g desc);
create reverse unique index idx4 on t1(g);
create index idx5 on t1(i(3));
alter table t1 add constraint foreign key (h) references x(a) on delete cascade;

insert into x values (1), (2), (3);
insert into t1 values (1, 1, 1, 1, 1, 1, 1, 1, 'abcd'), (2, 2, 2, 2, 2, 2, 2, 2, 'efgh'), (3, 3, 3, 3, 3, 3, 3, 3, 'abce');
truncate t1;

select count(*) from t1; 
select * from db_index where class_name = 't1' order by index_name; 
select * from db_index_key where class_name = 't1' order by index_name, key_attr_name; 
select is_nullable from db_attribute where class_name = 't1' and attr_name = 'c'; 

drop table t1;
drop table x;



create table base (id int primary key, b varchar (22) unique, c int, index idx (c));
create table derived under base (x int unique);

insert into base values (1, '1', 1), (2, '2', 2), (3, '3', 3), (4, '4', 4), (5, '5', 5);
insert into derived values (6, '6', 1, 1),(7, '7', 2, 2), (8, '8', 3, 3);

truncate base;

select count(*) from base; 
select count(*) from derived; 

select * from db_index where class_name = 'base' order by index_name; 
select * from db_index_key where class_name = 'base' order by index_name, key_attr_name; 

select * from db_index where class_name = 'derived' order by index_name; 
select * from db_index_key where class_name = 'derived' order by index_name, key_attr_name; 

select * from all base where id > 6 using index pk_base_id(+); 
select * from derived where id > 6 using index u_base_b(+); 

drop table base;
drop table derived;





create table pk (id int primary key);
create table fk (id int);
alter table fk add constraint foreign key (id) references pk(id);
insert into pk values (1);
insert into fk values (1), (1), (1);

truncate pk cascade; 

create table pk2 (id int primary key);
create table fk2 (id int);
alter table fk2 add constraint foreign key (id) references pk2(id) on delete cascade;
insert into pk2 values (1);
insert into fk2 values (1), (1), (1);

truncate pk2 cascade;

select count(*) from pk2; 
select count(*) from fk2; 

create table pk3 (id int primary key);
create table fk3 (id int);
alter table fk3 add constraint foreign key (id) references pk3(id) on delete set null;
insert into pk3 values (1);
insert into fk3 values (1), (1), (1);

truncate pk3 cascade;

select count(*) from pk3; 
select * from fk3; 

drop table fk;
drop table pk;
drop table fk2;
drop table pk2;
drop table fk3;
drop table pk3;
autocommit on;
