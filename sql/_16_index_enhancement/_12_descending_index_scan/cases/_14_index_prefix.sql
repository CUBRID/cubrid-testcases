-- test with prefix indexes
create table tree(id int not null, parentid int, text varchar(64) not null);

insert into tree values(1,6,	'AAA');
insert into tree values(2,6,	'AAB');
insert into tree values(3,6,	'AAC');
insert into tree values(4,6,	'AAD');
insert into tree values(5,6,	'AAE');
insert into tree values(6,31,	'AA');
insert into tree values(7,12,	'ABA');
insert into tree values(8,12,	'ABB');
insert into tree values(9,12,	'ABC');
insert into tree values(10,12,	'ABD');
insert into tree values(11,12,	'ABE');
insert into tree values(12,31,	'AB');
insert into tree values(13,18,	'ACA');
insert into tree values(14,18,	'ACB');
insert into tree values(15,18,	'ACC');
insert into tree values(16,18,	'ACD');
insert into tree values(17,18,	'ACE');
insert into tree values(18,31,	'AC');
insert into tree values(19,24,	'ADA');
insert into tree values(20,24,	'ADB');
insert into tree values(21,24,	'ADC');
insert into tree values(22,24,	'ADD');
insert into tree values(23,24,	'ADE');
insert into tree values(24,31,	'AD');
insert into tree values(25,30,	'AEA');
insert into tree values(26,30,	'AEB');
insert into tree values(27,30,	'AEC');
insert into tree values(28,30,	'AED');
insert into tree values(29,30,	'AEE');
insert into tree values(30,31,	'AE');
insert into tree values(31,156,	'A');
insert into tree values(32,37,	'BAA');
insert into tree values(33,37,	'BAB');
insert into tree values(34,37,	'BAC');
insert into tree values(35,37,	'BAD');
insert into tree values(36,37,	'BAE');
insert into tree values(37,62,	'BA');
insert into tree values(38,43,	'BBA');
insert into tree values(39,43,	'BBB');
insert into tree values(40,43,	'BBC');

create index i_tree_text on tree(text(2));

select /*+ recompile use_desc_idx */ left(text, 2) from tree where text > '';

drop index i_tree_text on tree;

create index i_tree_text on tree(text);

select /*+ recompile use_desc_idx */ text from tree where text > '';

drop table tree;
