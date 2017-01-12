--+ holdcas on;

drop table if exists b_child;

drop table if exists a_parent;

CREATE TABLE a_parent (id string primary key,  name VARCHAR); 
 
CREATE TABLE b_child (id string, parent_id string, constraint fk_parent_id FOREIGN KEY(parent_id) REFERENCES a_parent(id));

insert into a_parent values ('bbb','aaa'); 

insert into a_parent values (repeat('bbb',300),'aaa');

insert into a_parent values (repeat('bbe',300),repeat('aaa',300));

insert into a_parent values ('bbe',repeat('aaa',300));  

insert into b_child values ('aaa','bbb');

insert into b_child values (repeat('aaa',300),'bbb');
  
insert into b_child values (repeat('aaa',300),repeat('bbb',300));

create index idx_a on a_parent(id,name);

create index idx_b on b_child(id,parent_id);

select * from b_child group by parent_id having parent_id >'aaa';

select * from b_child where parent_id like 'b%' group by id,parent_id having parent_id>'bbb';

select * from a_parent group by id having id >'aaa'; 

select * from a_parent group by id,name having id >'aaa'; 

select count(*) from a_parent a,b_child b where a.id = b.parent_id group by b.parent_id having b.parent_id >'aaa';
 

drop table b_child;

drop table a_parent;

--+ holdcas off;