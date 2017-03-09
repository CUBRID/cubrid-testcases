--+ holdcas on;

drop table if exists b_child;

drop table if exists a_parent;

drop table if exists b_child_1;

drop table if exists a_parent_1;

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

select * from a_parent a,b_child b where a.id=b.parent_id order by 1,2,3;

select * from a_parent a,b_child b where a.id=b.parent_id group by a.id having a.id>'aa' using index idx_a order by 1;  

--- (1). hierarchical query
select tt.id,tt.parent_id from b_child tt connect by prior tt.id=tt.parent_id using index idx_b order by tt.id desc limit 1;

select tt.id,tt.name from a_parent tt start with tt.name='aaa' connect by prior tt.name=tt.id order by tt.name;

--- (2). join
select * from a_parent t1 inner join b_child t2 on t1.id=t2.parent_id using index idx_a order by t2.parent_id desc limit 1;

select * from a_parent t1 left outer join b_child t2 on t1.id=t2.parent_id where t1.name > 'a' order by t2.parent_id desc limit 1;

select * from a_parent t1 right outer join b_child t2 on t1.id=t2.parent_id where t2.parent_id > 'a' order by t2.parent_id desc limit 1;

select count(*) from a_parent natural left join b_child;   

--- (3). subquery
select t1.id,t1.name,(select t2.id from b_child t2 where t1.id = t2.parent_id order by t2.id limit 1) as aaa from a_parent t1 where t1.id > 'aa' limit 1;

--- (4). group by(CBRD-20613)
select * from b_child group by parent_id having parent_id >'aaa' order by 1,2;

--- (5). merge into
merge into b_child b using a_parent a on (b.parent_id=a.id) when matched then update set b.parent_id='bbe' where b.id='abcdef' when not matched then insert values(repeat('fisrt',300),repeat('bbe',300));

select disk_size(id),disk_size(parent_id) from b_child group by parent_id having parent_id >'aaa' order by 1,2;

--- (6). add primary key and foreign key

create table a_parent_1 as select * from a_parent;

create table b_child_1 as select * from a_parent;

alter table a_parent_1 add primary key(id,name);

alter table b_child_1 add constraint fk_parent_id FOREIGN KEY(id,name) REFERENCES a_parent_1(id,name);

select disk_size(a.id),disk_size(b.id),a.id,b.id from a_parent_1 a,b_child_1 b where a.id=b.id order by 1,2;


drop table b_child;

drop table a_parent;

drop table b_child_1;

drop table a_parent_1;

--+ holdcas off;