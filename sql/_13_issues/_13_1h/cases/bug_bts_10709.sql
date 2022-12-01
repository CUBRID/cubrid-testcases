--Test for 'CREATE INDEX' query updates only statistics for its B-tree 
--+ holdcas on;
create table tbl_1 (a int, b int);
create index idxa on tbl_1(a);
update statistics on tbl_1;

insert into tbl_1 values (1,2), (2,3), (3,4), (4,5), (5,6);
show index in tbl_1;


create table tbl_2 (a int);
insert into tbl_2 values (1), (2), (3);
create index idxa on tbl_2(a);
update statistics on tbl_2;
show index in tbl_2;


create table tbl_3 (a int, b int);
insert into tbl_3 values (1,2), (2,3), (3,4), (4,5), (5,6);
create index idxa on tbl_3(a);
create index idxb on tbl_3(b);
update statistics on tbl_3;
show index in tbl_3;

drop table tbl_1;
drop table tbl_2;
drop table tbl_3;

commit;

--+ holdcas off;
