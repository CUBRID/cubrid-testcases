--+ holdcas on;
create table tb (id int primary key, a int);
insert into tb values (4,4);
insert into tb values (1,1);
create index i_tb_a on tb(a);
insert into tb values (2,2);
insert into tb values (3,3);

--TEST: should use index i_tb_a and desc index scan
select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num() between 2 and 4;
select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num() between 2 and 4;
--TEST: should use index i_tb_a and desc index scan
select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num() <=2;
select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num() <=2;
--TEST: should use index i_tb_a and desc index scan
select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num() >=2;
select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num() >=2;

--TEST: should use index i_tb_a and desc index scan
select /*+ recompile */ a from tb where a between 1 and 3 group by a desc having groupby_num()-1 >=2;
select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num()-1 >=2;

insert into tb values (5,1);
insert into tb values (6,2);
insert into tb values (7,3);
insert into tb values (8,4);

--TEST: 
select /*+ recompile */ a from tb where a between 1 and 4 group by a desc having groupby_num()%2=0;
--TEST: 
select /*+ recompile */ a from tb where a between 1 and 4 group by a desc having groupby_num() in (0,2,4);
--TEST: 
select /*+ recompile */ a from tb where a between 3 and 1 group by a desc having groupby_num()-1 >=2;

drop table tb;

commit;
--+ holdcas off;
