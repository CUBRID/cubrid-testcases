-- This is a test case to verify the CBRD-24985 issue.

drop table if exists TB_RDRECORD, TB_RDFOLDER, subquery_big;

--create table
create table TB_RDRECORD (
    RCTR_ID         VARCHAR(30),
    FLS_ID          VARCHAR(30),
    DRC_YN          VARCHAR(30),
    DFLP_CNVR_STTS  VARCHAR(30)
);
insert into TB_RDRECORD values('0000001','20160000078754','1','');
insert into TB_RDRECORD values('0000001','20160000078753','1','');

create table  TB_RDFOLDER (
    RCTR_ID         VARCHAR(30),
    TRDV_CD         VARCHAR(30),
    FLS_ID          VARCHAR(30),
    PBRC_PRCS_stts  VARCHAR(30)
);
insert into TB_RDFOLDER values('0000001','000007Z','20160000078754','03');
insert into TB_RDFOLDER values('0000001','000007Z','20160000078753','03');

--select query
select a.*
from TB_RDRECORD a
where a.RCTR_ID = '0000001'
  and a.FLS_ID in (
            select F.FLS_ID
            from TB_RDFOLDER F
            where F.RCTR_ID = '0000001'
              and F.TRDV_CD = '000007Z'
              and F.FLS_ID  = '20160000078754'
              and F.PBRC_PRCS_STTS = '03'
      )
  and a.DRC_YN ='1'
  and ( a.DFLP_CNVR_STTS is null
        or a.DFLP_CNVR_STTS = ''
        or a.DFLP_CNVR_STTS = '0'
      );

select a.*
from TB_RDRECORD a
where a.RCTR_ID = '0000001'
  and a.FLS_ID in (
            select F.FLS_ID
            from TB_RDFOLDER F
            where F.RCTR_ID = '0000001'
              and F.TRDV_CD = '000007Z'
              and F.FLS_ID  = '20160000078753'
              and F.PBRC_PRCS_STTS = '03'
      )
  and a.DRC_YN ='1'
  and ( a.DFLP_CNVR_STTS is null
        or a.DFLP_CNVR_STTS = ''
        or a.DFLP_CNVR_STTS = '0'
      );

--update query
--The number of update statement execution results must be 1.

--@queryplan
update  TB_RDRECORD a
set a.drc_yn='1'
where a.RCTR_ID = '0000001'
  and a.FLS_ID in (
            select F.FLS_ID
            from TB_RDFOLDER F
            where F.RCTR_ID = '0000001'
              and F.TRDV_CD = '000007Z'
              and F.FLS_ID  = '20160000078754'
              and F.PBRC_PRCS_STTS = '03'
      )
  and a.DRC_YN ='1'
  and ( a.DFLP_CNVR_STTS is null
        or a.DFLP_CNVR_STTS = ''
        or a.DFLP_CNVR_STTS = '0'
      );

update  TB_RDRECORD a
set a.drc_yn='1'
where a.RCTR_ID = '0000001'
  and a.FLS_ID in (
            select F.FLS_ID
            from TB_RDFOLDER F
            where F.RCTR_ID = '0000001'
              and F.TRDV_CD = '000007Z'
              and F.FLS_ID  = '20160000078753'
              and F.PBRC_PRCS_STTS = '03'
      )
  and a.DRC_YN ='1'
  and ( a.DFLP_CNVR_STTS is null
        or a.DFLP_CNVR_STTS = ''
        or a.DFLP_CNVR_STTS = '0'
      );

--prepare
--@queryplan
prepare st from 'update TB_RDRECORD a  set a.drc_yn=1 WHERE a.FLS_ID in ( SELECT F.FLS_ID from TB_RDFOLDER F WHERE F.FLS_ID  = ? AND F.RCTR_ID = ?)';
EXECUTE st USING '20160000078754', '0000001';
EXECUTE st USING '20160000078753', '0000001';

--@queryplan
prepare st from 'select * from TB_RDRECORD a WHERE a.FLS_ID in ( SELECT F.FLS_ID from TB_RDFOLDER F WHERE F.FLS_ID  = ? AND F.RCTR_ID = ?)';
EXECUTE st USING '20160000078754', '0000001';
EXECUTE st USING '20160000078753', '0000001';

--CBRD-24073 (changed type)
create table subquery_big (col1 varchar(20), col2 varchar(20), col3 varchar(20));
select /*+ recompile */ count(*) from 
(select col2, avg(col3) from subquery_big group by col2) a,
(select col2, min(col3), max(col3) from subquery_big where col2=1 group by col2) b
where a.col2=b.col2;

drop prepare st;
drop table if exists TB_RDRECORD, TB_RDFOLDER, subquery_big;
