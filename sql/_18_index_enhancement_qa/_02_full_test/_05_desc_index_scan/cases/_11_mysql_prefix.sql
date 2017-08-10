--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

set system parameters 'compat_mode=mysql';

create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4,'443'),(5,4,'444'),(6,4,'441'), (1,1,'111111');
create index i_tb_b on tb(b(2));
insert into tb values (2,2,'22222'),(3,3,'3333');

--In fact, below query doesn't support DESC INDEX SCAN
select /*+ recompile */ * from tb where b between '1' and '44444' order by b desc;
--Bug for below one, DESC INDEX SCAN is support. And result is not expected.
select /*+ recompile use_desc_idx */ * from tb where b between '1' and '44444' using index i_tb_b;

drop table tb;

set system parameters 'compat_mode=cubrid';

set system parameters 'dont_reuse_heap_file=no';


commit;
--+ holdcas off;
