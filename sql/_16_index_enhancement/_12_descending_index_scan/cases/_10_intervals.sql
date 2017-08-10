-- test for range checkings
create table tree(id int not null, parentid int, text varchar(64) not null);

create index i_tree_id on tree(id);
create index i_tree_parentid on tree(parentid);

insert into tree values(1,6,'AAAAA');
insert into tree values(2,6,'AAAAB');
insert into tree values(3,6,'AAAAC');
insert into tree values(4,6,'AAAAD');
insert into tree values(5,6,'AAAAE');
insert into tree values(6,31,'AAAA');
insert into tree values(7,12,'AAABA');
insert into tree values(8,12,'AAABB');
insert into tree values(9,12,'AAABC');
insert into tree values(10,12,'AAABD');
insert into tree values(11,12,'AAABE');
insert into tree values(12,31,'AAAB');
insert into tree values(13,18,'AAACA');
insert into tree values(14,18,'AAACB');
insert into tree values(15,18,'AAACC');

create index i_tree_id_parentid_text on tree(id, parentid, text);

select /*+ use_desc_idx */ * from tree where id > 2 and id < 6;
select /*+ use_desc_idx */ * from tree where id >= 2 and id < 6;
select /*+ use_desc_idx */ * from tree where id > 2 and id <= 6;
select /*+ use_desc_idx */ * from tree where id >= 2 and id <= 6;

select /*+ use_desc_idx */ * from tree where id > 2 and id < 6 using index i_tree_id;
select /*+ use_desc_idx */ * from tree where id >= 2 and id < 6 using index i_tree_id;
select /*+ use_desc_idx */ * from tree where id > 2 and id <= 6 using index i_tree_id;
select /*+ use_desc_idx */ * from tree where id >= 2 and id <= 6 using index i_tree_id;

select /*+ use_desc_idx */ * from tree where id < 6 using index i_tree_id;
select /*+ use_desc_idx */ * from tree where id <= 6 using index i_tree_id;
select /*+ use_desc_idx */ * from tree where id < 6;
select /*+ use_desc_idx */ * from tree where id <= 6;

drop table tree;
