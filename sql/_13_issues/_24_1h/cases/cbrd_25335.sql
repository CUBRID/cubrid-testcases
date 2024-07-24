-- Problem where nodes without a join relationship are connected and incorrect results are output.

-- Join execution order error. 
-- See plan for more details.  
-- The result count of 1 before modifed was 4, which should be 2 in this case. 



drop table if exists tbl1;
drop table if exists tbl2;
drop table if exists tbl3;
drop table if exists tbl4;
drop table if exists tbl5;
drop table if exists tbl6;

create table tbl1(
	proj_rqst_no         CHARACTER VARYING
	,busi_cls             CHARACTER VARYING
);
insert into tbl1 select ROWNUM,ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tbl2(
     busi_cd              CHARACTER VARYING
);
insert into tbl2 select ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tbl3(
     rqst_no              CHARACTER VARYING
);
insert into tbl3 select ROWNUM from db_class a, db_class b, db_class c limit 1000;

create table tbl4(
     rqst_no              CHARACTER VARYING
     ,aprov_stat           CHARACTER VARYING 
);
insert into tbl4 select ROWNUM ,ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tbl5(
     comm_cd              CHARACTER VARYING
);
insert into tbl5 select ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tbl6(
     busi_cd              CHARACTER VARYING 
);
insert into tbl6 select ROWNUM from db_class a, db_class b, db_class c limit 2;

UPDATE STATISTICS ON tbl1,tbl2,tbl3,tbl4,tbl5,tbl6;

-- test
select /*+ RECOMPILE */
    1
from
    tbl1 A
    inner join tbl2 E on A.BUSI_CLS = E.BUSI_CD
    left outer join tbl3 H on A.PROJ_RQST_NO = H.RQST_NO
    inner join tbl4 F on H.RQST_NO = F.RQST_NO
    left outer join tbl5 G on F.APROV_STAT = G.COMM_CD
    inner join tbl6 Z on E.BUSI_CD = Z.BUSI_CD;

drop table tbl1;
drop table tbl2;
drop table tbl3;
drop table tbl4;
drop table tbl5;
drop table tbl6;
