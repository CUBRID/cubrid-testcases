--+ holdcas on;

drop table if exists t ,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_ij on t(i,j);
create index i_s_i on s(i);
create index i_s_ij on s(i,j);

merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_ij,i_t_i) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s; 

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


create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i) where i>1;
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_j,i_t_i) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i) where i>0;
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_i(+)) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_i(+)) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_i) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_ij) use_insert_idx(i_t_i(-)) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_i) use_insert_idx(i_t_i(-)) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where log10(s.i) >0
  when not matched then insert values(i,j);
select * from t order by 1;
select * from s order by 1;
drop table t,s;
create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index i_t_i on t(i);
create index i_t_j on t(log10(j));
create index i_s_i on s(log10(i));
create index i_s_ij on s(i,j);
merge /*+ recompile use_update_idx(i_s_i) use_insert_idx(i_t_i) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where log10(s.i) >0
  when not matched then insert values(i,j) where log10(s.j) >0;
  
  select * from t order by i;
drop table t,s;

commit;
--+ holdcas off;

