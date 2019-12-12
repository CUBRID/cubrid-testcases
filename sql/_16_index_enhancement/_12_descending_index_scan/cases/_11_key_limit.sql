-- test with key limit and various intervals
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
insert into tree values(16,18,'AAACD');
insert into tree values(17,18,'AAACE');
insert into tree values(18,31,'AAAC');
insert into tree values(19,24,'AAADA');
insert into tree values(20,24,'AAADB');
insert into tree values(21,24,'AAADC');
insert into tree values(22,24,'AAADD');
insert into tree values(23,24,'AAADE');
insert into tree values(24,31,'AAAD');
insert into tree values(25,30,'AAAEA');
insert into tree values(26,30,'AAAEB');
insert into tree values(27,30,'AAAEC');
insert into tree values(28,30,'AAAED');
insert into tree values(29,30,'AAAEE');
insert into tree values(30,31,'AAAE');

create index i_tree_id_parentid_text on tree(id, parentid, text);

select /*+ use_desc_idx */ id from tree where id <= 10 using index i_tree_id keylimit 0;
select /*+ use_desc_idx */ id from tree where id < 11 using index i_tree_id keylimit 1;
select /*+ use_desc_idx */ id from tree where id <= 12 using index i_tree_id keylimit 2;
select /*+ use_desc_idx */ id from tree where id >= 13 using index i_tree_id keylimit 3;
select /*+ use_desc_idx */ id from tree where id < 14 using index i_tree_id keylimit 4;
select /*+ use_desc_idx */ id from tree where id <= 15 using index i_tree_id keylimit 5;
select /*+ use_desc_idx */ id from tree where id > 16 using index i_tree_id keylimit 6;
select /*+ use_desc_idx */ id from tree where id > 17 using index i_tree_id keylimit 7;
select /*+ use_desc_idx */ id from tree where id <= 18 using index i_tree_id keylimit 8;
select /*+ use_desc_idx */ id from tree where id >= 19 using index i_tree_id keylimit 9;
select /*+ use_desc_idx */ id from tree where id < 20 using index i_tree_id keylimit 1, 1;
select /*+ use_desc_idx */ id from tree where id <= 21 using index i_tree_id keylimit 2, 3;
select /*+ use_desc_idx */ id from tree where id < 22 using index i_tree_id keylimit 4, 5;
select /*+ use_desc_idx */ id from tree where id < 23 using index i_tree_id keylimit 6, 7;
select /*+ use_desc_idx */ id from tree where id <= 24 using index i_tree_id keylimit 8, 9;
select /*+ use_desc_idx */ id from tree where id < 25 using index i_tree_id keylimit 9, 8;
select /*+ use_desc_idx */ id from tree where id < 26 using index i_tree_id keylimit 4, 11;
select /*+ use_desc_idx */ id from tree where id > 27 using index i_tree_id keylimit 10, 4;
select /*+ use_desc_idx */ id from tree where id < 28 using index i_tree_id keylimit 11, 9;
select /*+ use_desc_idx */ id from tree where id < 29 using index i_tree_id keylimit 19, 4;

drop table tree;
