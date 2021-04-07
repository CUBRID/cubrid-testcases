--+ holdcas on;

drop if exists t,s; 

create table t (i int, j int);
create table s (i int, j int);

insert t values (1,1),(2,2),(3,3);
insert s values (1,11),(2,22),(4,44),(5,55),(7,77),(8,88);

create index idx1 on t(i);
create index idx2 on t(i,j);
create index idx1 on s(i);
create index idx2 on s(i,j);

--Test error
merge /*+ recompile use_update_idx(idx2) use_insert_idx(idx2,idx1) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);


merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1 and rownum <>1
  when not matched then insert values(i,j);

  
merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1 and rownum <10
  when not matched then insert values(i,j);

merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into t using s 
  on t.i=s.i+1 
  when matched then update set t.j=s.j where s.i <> 1 and rownum <10
  when not matched then insert values(i,j);


merge /*+ NO_STATS */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);


merge /*+ USE_MERGE */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);


merge /*+ USE_IDX(idx2)  */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);

merge /*+ USE_IDX(idx2)  */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i-1,j-1) ;



create index idx5 on t(i desc ,j desc );
create index idx6 on s(i desc ,j desc );


merge /*+ USE_DESC_IDX(idx5)  */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i-1,j-1) ;

  
merge /*+ USE_DESC_IDX(idx6,idx5)  */ 
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i-1,j-1) ;

select * from t order by 1;
select * from s order by 1;

drop table if exists t,s,tt; 

create table t (i int, j int) ;
create table s (i int, j int)  ;

insert t values (1,1),(2,2);
insert s values (1,11),(2,22);

create index idx1 on t(i);
create index idx2 on t(i,j);
create index idx1 on s(i);
create index idx2 on s(i,j);

create table tt as select * from t;

merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);


merge /*+ recompile use_update_idx(s.idx2) use_insert_idx(t.idx2,t.idx1) */
  into (select * from tt ) t using s 
  on t.i=s.i 
  when matched then update set t.j=s.j where s.i <> 1
  when not matched then insert values(i,j);

create index idx3 on tt(i);
create index idx4 on tt(i,j);


merge /*+ recompile use_update_idx(t.idx2) use_insert_idx(t.idx2,t.idx1) */
  into  t using (select * from tt)tt 
  on t.i=tt.i 
  when matched then update set t.j=tt.j where tt.i <> 1
  when not matched then insert values(i,j);


merge /*+ recompile use_update_idx(t.idx2) use_insert_idx(t.idx2,t.idx1) */
  into  t using tt 
  on t.i=tt.i 
  when matched then update set t.j=tt.j where tt.i <> 1
  when not matched then insert values(i,j);

  
merge /*+ recompile use_update_idx(t.idx2) use_insert_idx(t.idx2,t.idx1) */
  into  t using tt 
  on t.i=tt.i 
  when matched then update set t.j=tt.j where tt.i <> 1
  delete where(t.i=tt.i )
  when not matched then insert values(i,j);

select * from t order by 1;
select * from s order by 1;

select * from tt order by 1;


drop table if exists t,s,tt; 

commit;
--+ holdcas off;

