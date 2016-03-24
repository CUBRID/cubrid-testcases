--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';


create table tb2 ( col1 int primary key, col2 varchar(16));
insert into tb2 values(1, '1');
create index i_tb2 on tb2(col1, col2);
delete from tb2;

select * from tb2 order by 1 desc,2 desc;

drop table tb2;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;


