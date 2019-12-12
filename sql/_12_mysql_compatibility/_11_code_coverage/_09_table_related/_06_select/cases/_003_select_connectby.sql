create table tree(id int not null, parentid int, text varchar(32));

create index idx on tree(parentid);

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');


	
select level as lvl,count(*) as cnt from tree start with parentid is null connect by parentid=prior id group by level;


drop table tree;


create table tree(id set(integer) not null, parentid set (integer), text varchar(32));

create index idx on tree(parentid);

insert into tree values({1},null,'A');
insert into tree values({2},null,'B');
insert into tree values({3},{1},'AA');
insert into tree values({4},{1},'AB');
insert into tree values({5},{2},'BA');
insert into tree values({6},{2},'BB');
insert into tree values({7},{3},'AAB');


	
select level as lvl,count(*) as cnt from tree start with parentid is null connect by parentid=prior id group by level;


drop table tree;
