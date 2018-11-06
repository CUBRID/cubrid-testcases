-- create tables
drop table if exists t_d_1,t_d_2;
create table t_d_1(i int);
insert into t_d_1 select rownum*2 from db_root connect by level<=100;
create table t_d_2(i int);
insert into t_d_2 select rownum*3 from db_root connect by level<=100;


drop table if exists t;

create table t(id int primary key auto_increment, a int, b int, c int, d int);

insert into t (a,b,c,d) select mod(rownum,10), mod(rownum,10), mod(rownum,10), rownum from db_class x1, db_class x2, db_class x3 limit 15000;

insert into t (a,b,c,d) values (null, null, 888, null);

-- null keys
insert into t (a,b,c,d) values (null, null, null, null);

insert into t (a,b,c,d) values (0, null, null, null);

insert into t (a,b,c,d) values (1, null, null, null);

insert into t (a,b,c,d) values (2, null, null, null);

insert into t (a,b,c,d) values (3, null, null, null);

insert into t (a,b,c,d) values (4, null, null, null);

insert into t (a,b,c,d) values (5, null, null, null);

insert into t (a,b,c,d) values (6, null, null, null);

insert into t (a,b,c,d) values (7, null, null, null);

insert into t (a,b,c,d) values (8, null, null, null);

insert into t (a,b,c,d) values (9, null, null, null);

insert into t (a,b,c,d) values (0, 0, null, null);

insert into t (a,b,c,d) values (1, 1, null, null);

insert into t (a,b,c,d) values (2, 2, null, null);

insert into t (a,b,c,d) values (3, 3, null, null);

insert into t (a,b,c,d) values (4, 4, null, null);

insert into t (a,b,c,d) values (5, 5, null, null);

insert into t (a,b,c,d) values (6, 6, null, null);

insert into t (a,b,c,d) values (7, 7, null, null);

insert into t (a,b,c,d) values (8, 8, null, null);

insert into t (a,b,c,d) values (9, 9, null, null);

insert into t (a,b,c,d) values (0, 0, 0, null);

insert into t (a,b,c,d) values (1, 1, 1, null);

insert into t (a,b,c,d) values (2, 2, 2, null);

insert into t (a,b,c,d) values (3, 3, 3, null);

insert into t (a,b,c,d) values (4, 4, 4, null);

insert into t (a,b,c,d) values (5, 5, 5, null);

insert into t (a,b,c,d) values (6, 6, 6, null);

insert into t (a,b,c,d) values (7, 7, 7, null);

insert into t (a,b,c,d) values (8, 8, 8, null);

insert into t (a,b,c,d) values (9, 9, 9, null);

-- min keys
insert into t (a,b,c,d) values (-2147483648, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (0, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (1, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (2, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (3, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (4, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (5, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (6, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (7, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (8, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (9, -2147483648, -2147483648, -2147483648);

insert into t (a,b,c,d) values (0, 0, -2147483648, -2147483648);

insert into t (a,b,c,d) values (1, 1, -2147483648, -2147483648);

insert into t (a,b,c,d) values (2, 2, -2147483648, -2147483648);

insert into t (a,b,c,d) values (3, 3, -2147483648, -2147483648);

insert into t (a,b,c,d) values (4, 4, -2147483648, -2147483648);

insert into t (a,b,c,d) values (5, 5, -2147483648, -2147483648);

insert into t (a,b,c,d) values (6, 6, -2147483648, -2147483648);

insert into t (a,b,c,d) values (7, 7, -2147483648, -2147483648);

insert into t (a,b,c,d) values (8, 8, -2147483648, -2147483648);

insert into t (a,b,c,d) values (9, 9, -2147483648, -2147483648);

insert into t (a,b,c,d) values (0, 0, 0, -2147483648);

insert into t (a,b,c,d) values (1, 1, 1, -2147483648);

insert into t (a,b,c,d) values (2, 2, 2, -2147483648);

insert into t (a,b,c,d) values (3, 3, 3, -2147483648);

insert into t (a,b,c,d) values (4, 4, 4, -2147483648);

insert into t (a,b,c,d) values (5, 5, 5, -2147483648);

insert into t (a,b,c,d) values (6, 6, 6, -2147483648);

insert into t (a,b,c,d) values (7, 7, 7, -2147483648);

insert into t (a,b,c,d) values (8, 8, 8, -2147483648);

insert into t (a,b,c,d) values (9, 9, 9, -2147483648);

-- max keys
insert into t (a,b,c,d) values (2147483647, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (0, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (1, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (2, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (3, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (4, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (5, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (6, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (7, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (8, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (9, 2147483647, 2147483647, 2147483647);

insert into t (a,b,c,d) values (0, 0, 2147483647, 2147483647);

insert into t (a,b,c,d) values (1, 1, 2147483647, 2147483647);

insert into t (a,b,c,d) values (2, 2, 2147483647, 2147483647);

insert into t (a,b,c,d) values (3, 3, 2147483647, 2147483647);

insert into t (a,b,c,d) values (4, 4, 2147483647, 2147483647);

insert into t (a,b,c,d) values (5, 5, 2147483647, 2147483647);

insert into t (a,b,c,d) values (6, 6, 2147483647, 2147483647);

insert into t (a,b,c,d) values (7, 7, 2147483647, 2147483647);

insert into t (a,b,c,d) values (8, 8, 2147483647, 2147483647);

insert into t (a,b,c,d) values (9, 9, 2147483647, 2147483647);

insert into t (a,b,c,d) values (0, 0, 0, 2147483647);

insert into t (a,b,c,d) values (1, 1, 1, 2147483647);

insert into t (a,b,c,d) values (2, 2, 2, 2147483647);

insert into t (a,b,c,d) values (3, 3, 3, 2147483647);

insert into t (a,b,c,d) values (4, 4, 4, 2147483647);

insert into t (a,b,c,d) values (5, 5, 5, 2147483647);

insert into t (a,b,c,d) values (6, 6, 6, 2147483647);

insert into t (a,b,c,d) values (7, 7, 7, 2147483647);

insert into t (a,b,c,d) values (8, 8, 8, 2147483647);

insert into t (a,b,c,d) values (9, 9, 9, 2147483647);

-- all possibilities
create index i_t_all on t(a asc, b asc, c asc, d asc);

;au off
WITH cte_fnrZF2Xrn AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fnrZF2Xrn);
select * from t_d_1;
rollback;


WITH cte_s46ywdmiu AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_s46ywdmiu);
select * from t_d_1;
rollback;


WITH cte_gRnuOqrAC AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_gRnuOqrAC);

select * from t_d_1;
rollback;


WITH cte_fLcntxuU3 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fLcntxuU3);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_a1lfeKECr AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_a1lfeKECr);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_g3VzRAl0Z AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_g3VzRAl0Z);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_JSghVGPRG AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_JSghVGPRG);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_hC2XcO3XH AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_hC2XcO3XH);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_RtTOPQDLG AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RtTOPQDLG);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_qOxW521Dr AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_qOxW521Dr);
select * from t_d_1 where i<=20 order by 1;
rollback;


alter table t drop index i_t_all;

create index i_t_all on t(a asc, b asc, c asc, d desc);

WITH cte_LtSBb5Tx1 AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_LtSBb5Tx1);

select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_eJWLICUdw AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_eJWLICUdw);

select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_PmdQawXeU AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_PmdQawXeU);

select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_8huqw4ZFH AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_8huqw4ZFH);

select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_cdoQcYrkK AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_cdoQcYrkK);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_IArpoWBHv AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_IArpoWBHv);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_VNhv7qQa9 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_VNhv7qQa9);
select * from t_d_1;
rollback;


WITH cte_wlFaEOoi7 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_wlFaEOoi7);
select * from t_d_1;
rollback;



WITH cte_PoplCnjyu AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_PoplCnjyu);
select * from t_d_1;
rollback;



WITH cte_J5LJx8aio AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_J5LJx8aio);
select * from t_d_1;
rollback;



alter table t drop index i_t_all;

create index i_t_all on t(a asc, b asc, c desc, d asc);

WITH cte_I0OMKmtuu AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_I0OMKmtuu);

select * from t_d_1;
rollback;

WITH cte_tY0A4xyAC AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_tY0A4xyAC);
select * from t_d_1;
rollback;


WITH cte_JnKoekUwi AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_JnKoekUwi);
select * from t_d_1;
rollback;


WITH cte_fcYX2vlrM AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fcYX2vlrM);
select * from t_d_1;
rollback;


WITH cte_WqxIEkTde AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_WqxIEkTde);

select * from t_d_1;
rollback;


WITH cte_QZmnWehCk AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_QZmnWehCk);
select * from t_d_1;
rollback;


WITH cte_QNK3BDyGX AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_QNK3BDyGX);
select * from t_d_1;
rollback;


WITH cte_dijYRDxJI AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_dijYRDxJI);
select * from t_d_1;
rollback;


WITH cte_bxnmFu5MM AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_bxnmFu5MM);
select * from t_d_1;
rollback;


WITH cte_ayelGOLZ1 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_ayelGOLZ1);
select * from t_d_1;
rollback;


alter table t drop index i_t_all;

create index i_t_all on t(a asc, b asc, c desc, d desc);

WITH cte_6E0oM9ScF AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_6E0oM9ScF);
select * from t_d_1;
rollback;


WITH cte_9dyoGyhL2 AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_9dyoGyhL2);
select * from t_d_1;
rollback;


WITH cte_j8ZOeL6g5 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_j8ZOeL6g5);
select * from t_d_1;
rollback;


WITH cte_eMpryijPV AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_eMpryijPV);
select * from t_d_1;
rollback;


WITH cte_bq6Nfc2bY AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_bq6Nfc2bY);
select * from t_d_1;
rollback;


WITH cte_BqdGxMLG7 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_BqdGxMLG7);
select * from t_d_1;
rollback;

WITH cte_zxIK7JwYP AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_zxIK7JwYP);

WITH cte_KzFsUQ8eb AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_KzFsUQ8eb);

WITH cte_UWx3iihf7 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_UWx3iihf7);

WITH cte_hLT7jr63J AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_hLT7jr63J);

alter table t drop index i_t_all;

create index i_t_all on t(a asc, b desc, c asc, d asc);

WITH cte_IQvAoe1Cw AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_IQvAoe1Cw);

WITH cte_8M2LIdNaH AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_8M2LIdNaH);

WITH cte_XFD3nV7nK AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_XFD3nV7nK);

WITH cte_fEQ5PcXW1 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fEQ5PcXW1);

WITH cte_Wpuhn9dZm AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Wpuhn9dZm);

WITH cte_7McEA4L2J AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_7McEA4L2J);

WITH cte_9nNEttcz7 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_9nNEttcz7);

WITH cte_fBGUBPbHA AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fBGUBPbHA);

WITH cte_dD1u4pJkE AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_dD1u4pJkE);

WITH cte_ex5D4r8w1 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_ex5D4r8w1);

alter table t drop index i_t_all;

create index i_t_all on t(a asc, b desc, c asc, d desc);

WITH cte_smDlM5baK AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_smDlM5baK);

WITH cte_OQkEsK5vL AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_OQkEsK5vL);

WITH cte_faWIQ1PGV AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_faWIQ1PGV);

WITH cte_XNcMTnnMY AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_XNcMTnnMY);

WITH cte_GbTaKuVBE AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_GbTaKuVBE);

WITH cte_pr5RYH18v AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_pr5RYH18v);

WITH cte_Gnn5LLfxM AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Gnn5LLfxM);

WITH cte_uZGjptRaI AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_uZGjptRaI);

WITH cte_RJlDhWcwi AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RJlDhWcwi);

WITH cte_9o9F1dyys AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_9o9F1dyys);

alter table t drop index i_t_all;

create index i_t_all on t(a asc, b desc, c desc, d asc);

WITH cte_L4CtzLxGN AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_L4CtzLxGN);

WITH cte_fUZVyKanJ AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_fUZVyKanJ);

WITH cte_gToQHY1HK AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_gToQHY1HK);

WITH cte_8ELmRrkTm AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_8ELmRrkTm);

WITH cte_BrpLY8lTF AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_BrpLY8lTF);

WITH cte_VQRsMyR3i AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_VQRsMyR3i);

WITH cte_7tvK5piDY AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_7tvK5piDY);

WITH cte_3shLNcjV8 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_3shLNcjV8);

WITH cte_kTrdyXYog AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_kTrdyXYog);

WITH cte_VoKXMOSz8 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_VoKXMOSz8);

alter table t drop index i_t_all;

create index i_t_all on t(a asc, b desc, c desc, d desc);

WITH cte_SEv417gvv AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_SEv417gvv);

WITH cte_RuT420L6u AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RuT420L6u);

WITH cte_cAny0Dbqt AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_cAny0Dbqt);

WITH cte_AycBZdbWi AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_AycBZdbWi);

WITH cte_9TYkdBSpX AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_9TYkdBSpX);

WITH cte_A8nz7tIPx AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_A8nz7tIPx);

WITH cte_cja7fDBmq AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_cja7fDBmq);

WITH cte_XLwF7Nd6n AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_XLwF7Nd6n);

WITH cte_MVgKisZPn AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_MVgKisZPn);

WITH cte_bCm0OnLDv AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_bCm0OnLDv);

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b asc, c asc, d asc);

WITH cte_cCN6EckZN AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_cCN6EckZN);

WITH cte_VjIelQ0ju AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_VjIelQ0ju);

WITH cte_HDrd6eK2H AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_HDrd6eK2H);

WITH cte_Xi2IpEIKe AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Xi2IpEIKe);

WITH cte_MmUrFK1zQ AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_MmUrFK1zQ);

WITH cte_kMeLGnV8a AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_kMeLGnV8a);

WITH cte_RQDweZnGE AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RQDweZnGE);

WITH cte_Wjy18jmnS AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Wjy18jmnS);

WITH cte_wz8WSkc80 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_wz8WSkc80);

WITH cte_jsWnBPD63 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_jsWnBPD63);

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b asc, c asc, d desc);

WITH cte_Xoxq2x941 AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Xoxq2x941);

WITH cte_5fQSP3A0a AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_5fQSP3A0a);

WITH cte_rNWfbD05k AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_rNWfbD05k);

WITH cte_9AGo46X5L AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_9AGo46X5L);

WITH cte_3T2J8u3Y9 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_3T2J8u3Y9);

WITH cte_DvXkZxD9m AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_DvXkZxD9m);

WITH cte_kWSrvmRvr AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_kWSrvmRvr);

WITH cte_XJzcpX0Dv AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_XJzcpX0Dv);

WITH cte_8V4M5FuGq AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_8V4M5FuGq);

WITH cte_ay4MZdekT AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_ay4MZdekT);

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b asc, c desc, d asc);

WITH cte_aub22Ynhr AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_aub22Ynhr);

WITH cte_ejZK59JHN AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_ejZK59JHN);

WITH cte_248IQBNRJ AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_248IQBNRJ);

WITH cte_euO9adO4F AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_euO9adO4F);

WITH cte_MouspfbNV AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_MouspfbNV);

WITH cte_chor3MzpV AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_chor3MzpV);

WITH cte_Hlichx875 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Hlichx875);

WITH cte_3nCO5kjGz AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_3nCO5kjGz);

WITH cte_24DIyJV3o AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_24DIyJV3o);

WITH cte_k4ugVZMCW AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_k4ugVZMCW);
select * from t_d_1 where i<=20 order by 1;
rollback;


alter table t drop index i_t_all;

create index i_t_all on t(a desc, b asc, c desc, d desc);

WITH cte_TPDyrzaCq AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_TPDyrzaCq);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_Ffr2sOm8w AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Ffr2sOm8w);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_svRECvxHE AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_svRECvxHE);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_QjUSO0CmI AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_QjUSO0CmI);

WITH cte_EkiZwWcCF AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_EkiZwWcCF);

WITH cte_jukryB8eN AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_jukryB8eN);

WITH cte_2iwPN3Ocj AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_2iwPN3Ocj);

WITH cte_D5bYPpJtR AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_D5bYPpJtR);

WITH cte_vFM4HgUPh AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_vFM4HgUPh);

WITH cte_anmZpcFUZ AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_anmZpcFUZ);

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b desc, c asc, d asc);

WITH cte_FhmQukdEV AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_FhmQukdEV);

WITH cte_BZhJF3ijy AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_BZhJF3ijy);

WITH cte_IjdgTNYaS AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_IjdgTNYaS);

WITH cte_Kilocn5jl AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Kilocn5jl);

WITH cte_5hXQNXRKt AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_5hXQNXRKt);

WITH cte_32agIeQpS AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_32agIeQpS);

WITH cte_eqpEb1hgx AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_eqpEb1hgx);

WITH cte_RurH3rcg7 AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RurH3rcg7);

WITH cte_hGjZBD1Bv AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_hGjZBD1Bv);

WITH cte_DkSbXZEma AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_DkSbXZEma);

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b desc, c asc, d desc);

WITH cte_X9NKe8xHd AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_X9NKe8xHd);

WITH cte_YvW0Z5HzQ AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_YvW0Z5HzQ);

WITH cte_jL9hNL1KA AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_jL9hNL1KA);

WITH cte_d0ZME7yHm AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_d0ZME7yHm);

WITH cte_3R94PS5VR AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_3R94PS5VR);

WITH cte_DhALGDlcW AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_DhALGDlcW);

WITH cte_crVp3UBOd AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_crVp3UBOd);

WITH cte_nYtFHvpLd AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_nYtFHvpLd);

WITH cte_X6YG47oil AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_X6YG47oil);

WITH cte_Mkzreps6u AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_Mkzreps6u);
select * from t_d_1 where i<=20 order by 1;
rollback;


alter table t drop index i_t_all;

create index i_t_all on t(a desc, b desc, c desc, d asc);

WITH cte_q1l54Yaga AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_q1l54Yaga);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_qjDKfAgs3 AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_qjDKfAgs3);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_jpGnscBjU AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_jpGnscBjU);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_2e9i9tDCZ AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_2e9i9tDCZ);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_K6cOFEbKu AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_K6cOFEbKu);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_YG826b0Cw AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_YG826b0Cw);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_o2K6usKKE AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_o2K6usKKE);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_BU3ekUQKV AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_BU3ekUQKV);

WITH cte_S0t8og3fl AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_S0t8og3fl);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_aaC7mXSqs AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_aaC7mXSqs);
select * from t_d_1 where i<=20 order by 1;
rollback;

alter table t drop index i_t_all;

create index i_t_all on t(a desc, b desc, c desc, d desc);

WITH cte_vwbiZrmO5 AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_vwbiZrmO5);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_0ZXByfjUY AS
(
select /*+ recompile index_ls */ a from t where a=4 group by a desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_0ZXByfjUY);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_HU0z89D8V AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_HU0z89D8V);
select * from t_d_1 where i<=20 order by 1;
rollback;

WITH cte_52ymYOzsx AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_52ymYOzsx);

select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_ZaIVvWAks AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_ZaIVvWAks);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_7RE4vnfSP AS
(
select /*+ recompile index_ls */ a, b from t where a=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_7RE4vnfSP);
select * from t_d_1 where i<=20 order by 1;
rollback;


WITH cte_zlQNR47iS AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_zlQNR47iS);
select * from t_d_1 where i<=20 order by 1;
rollback;




WITH cte_oQTQhSuEI AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_oQTQhSuEI);
select * from t_d_1 where i<=20 order by 1;
rollback;





WITH cte_nebYcDSjP AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a desc, b
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_nebYcDSjP);
select * from t_d_1 where i<=20 order by 1;
rollback;



WITH cte_RCIfzhkTL AS
(
select /*+ recompile index_ls */ a, b from t where a=4 and b=4 group by a, b desc
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i >=(select count(*) from cte_RCIfzhkTL);
select * from t_d_1 where i<=20 order by 1;
rollback;


alter table t drop index i_t_all;
commit;
;au on

-- cleanup
drop table t;



