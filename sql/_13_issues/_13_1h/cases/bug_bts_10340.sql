set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop if exists t,s; 

create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index idx1 on t(i);
create index idx2 on t(i,j);
create index idx1 on s(i);
create index idx2 on s(i,j);

merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);

select * from t order by 1;
select * from s order by 1;

drop table t,s;

create table s (i int, j int);
create table t (i int, j int);
create view v (i int, j int) as select * from t;

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_ij on t(i,j);


merge /*+ recompile use_update_idx(i_t_i) use_insert_idx(i_t_ij) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);

merge /*+ recompile use_update_idx(i_t_i,i_t_ij) use_insert_idx(i_t_ij,i_t_ij) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);

merge /*+ recompile use_update_idx() use_insert_idx() */
  into v using t
  on v.i=t.i 
  when matched then update set v.j=t.j where t.i <> 1
  when not matched then insert values(i,j);


merge /*+ recompile use_update_idx(i_t_i,i_t_ij) use_insert_idx(i_t_ij,i_t_ij) */
  into t using v
  on v.i=t.i 
  when matched then update set t.j=v.j where t.i <> 1
  when not matched then insert values(i,j);

select * from t order by 1;
select * from s order by 1;

drop table t,s;
drop v;
commit;
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
