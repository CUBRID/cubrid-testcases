-- code coverage test
create table test_table(id int not null, treeid int, age int, text varchar(32));

insert into test_table values(3, 1, 0, 'BAA');
insert into test_table values(8, null, 0, 'C');
insert into test_table values(5, 2, 0, 'CBA');
insert into test_table values(2, null, 0, 'A');
insert into test_table values(1, null, 0, null);
insert into test_table values(4, 1, 0, 'AB');
insert into test_table values(7, 6, 0, 'CBBA');
insert into test_table values(6, 2, 1, 'DBB');

create index idx1 on test_table(id);
create index idx2 on test_table(treeid);
create index idx3 on test_table(text);
create index idx4 on test_table(id, text);
create index idx5 on test_table(id, treeid, text);
create index idx6 on test_table(id, treeid);
create index idx7 on test_table(treeid, id);

select * from test_table where id > 0;
select * from test_table order by id;
select t.treeid from (select * from test_table where treeid is not null order by treeid) as t;
select t.treeid from (select * from test_table where treeid is not null or treeid is null order by treeid) as t;
select t.id, t.treeid from (select * from test_table where treeid > 0 order by id, treeid) as t;
select t.id, t.treeid, t.text from (select * from test_table where treeid = 1 order by id, text) as t;
select t.id, t.treeid, t.text from (select * from test_table where treeid = 1 and text = 'BAA' order by id) as t;
select t.treeid from (select * from test_table where treeid <> 1 order by treeid) as t;
select t.treeid from (select * from test_table where treeid < 1 or treeid <> 6 order by treeid) as t;
select t.id, t.treeid from (select * from test_table where treeid > 0 order by id) as t;
select t.id, t.treeid, t.text from (select * from test_table where id = 5 and treeid = 2 order by text) as t;

drop table test_table;
