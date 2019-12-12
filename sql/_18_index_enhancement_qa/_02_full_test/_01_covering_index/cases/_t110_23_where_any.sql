--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int );
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);

create index i_tb_a on tb(a);

select /*+ recompile */ a from tb where a=any{1,2};
select /*+ recompile */ a from tb where a=some{1,2};
select /*+ recompile */ a from tb where a=all{1,2};

drop table tb;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
