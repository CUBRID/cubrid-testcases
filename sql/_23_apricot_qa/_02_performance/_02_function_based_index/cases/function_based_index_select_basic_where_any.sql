--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table tb (a double );
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);

create index i_tb_a on tb(log10(a));

select /*+ recompile */ a from tb where log10(a)=any{0,1,2};
select /*+ recompile */ a from tb where log10(a)=some{0,1,2};
select /*+ recompile */ a from tb where log10(a)=all{0,1,2};

drop table tb;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
