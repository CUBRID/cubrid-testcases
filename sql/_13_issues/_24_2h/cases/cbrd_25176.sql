--There are cases where problems arise when deduplicate indexes are created with FK

set system parameters 'deduplicate_key_level=0';

drop table if exists b_child;
drop table if exists a_parent;
create table a_parent (id string,  name VARCHAR);
create table b_child  (id string, name VARCHAR);
insert into a_parent values ('bbb','aaa'), (repeat('bbb',300),'aaa'), (repeat('bbe',300),repeat('aaa',300)),('bbe',repeat('aaa',300));
insert into b_child select * from a_parent;
alter table a_parent add primary key(id,name);

alter table b_child add constraint fk_id_name1 FOREIGN KEY(id,name) with deduplicate=13 REFERENCES a_parent(id,name);

alter table b_child drop constraint fk_id_name1;

drop table b_child;
drop table a_parent;
