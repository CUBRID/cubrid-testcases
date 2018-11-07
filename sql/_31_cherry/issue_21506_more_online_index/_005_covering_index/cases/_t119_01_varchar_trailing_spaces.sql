--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tbl(c varchar(22));
insert into tbl values ('a ');
insert into tbl values ('a  ');
insert into tbl values (' a');
create index i_tbl_c on tbl (c) with online;
select c + 'z' from tbl where c > ' ';
select c + 'z' from tbl order by c;

drop table tbl;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
