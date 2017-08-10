--test
drop table if exists t,s,u; 
create table t (a int, b enum('1','2','3','4','5'), c int, d int, e int) ;
insert into t select rownum,1 ,rownum+2,rownum,rownum+2 from db_class a,db_class b ,db_class c limit 50000;
create index idx_a_b_cd_d_ed on t (a, b, c desc, d, e desc);
create index idx_a_b_cd_d on t (a, b, c desc, d);
create index idx_a_c_b_d on t (a, c, b desc, d);
create index idx_a_d_c_b on t (a, d, c desc, b);
create index idx_d_a_c_b on t (d, a, c desc,b);
create index idx_c_a_d_b on t (c, a, d desc,b);
create index idx_c_a_d_b_1 on t (c, a, d ,b);

--check
select * from t where a in (1,3) and b = 1 order by c desc, d limit 5;

--test
drop table if exists t,s,u;
