-- This test case verifies CBRD-24828 issue.
-- Using udf() and binding variables in update queries results in Execute error(-495).

drop table if exists tp_user;
create table tp_user (
        usr_no int primary key,
        usr_id varchar(20),
        usr_nm varchar(30),
        user_pswd varchar(200),
        use_yn  char(1),
        dept_cd varchar(10),
        authrt_cd varchar(10),
        usr_eml_addr varchar(100),
        usr_mbl_telno varchar(20),
        jbps_cd varchar(10),
        jbgd_cd varchar(10),
        wrc_telno varchar(20),
        wrc_fxno varchar(20),
        home_telno varchar(20),
        tkcg_work varchar(200),
        photo_file_nm varchar(100),
        oa_authrt_yn char(1),
        dept_head_yn char(1),
        hdof_se_cd char(1),
        brdt varchar(8),
        brdt_se_cd char(1),
        cns_yn char(1),
        dic varchar(30),
        rgrt_id varchar(20),
        reg_dt datetime,
        mdfr_id varchar(20),
        mdfcn_dt datetime,
        cntn_ip varchar(20),
        cntn_os varchar(30),
        cntn_login_yn varchar(1)
);

create index idx1 on tp_user (usr_id);

insert into tp_user set
        usr_no=123,
        usr_id='info',
        usr_nm='testnm',
        dept_cd='9876543',
        authrt_cd='AAA001',
        usr_eml_addr='info@cubrid.jr',
        usr_mbl_telno='010-1234-5678',
        jbps_cd='0067600',
        jbgd_cd='22244',
        wrc_telno='01)234-5678',
        wrc_fxno='01)1234-1234',
        home_telno='',
        tkcg_work='testwork11',
        oa_authrt_yn='Y',
        dept_head_yn='Y',
        brdt='19000101',
        brdt_se_cd='1',
        dic='M20-00001',
        mdfr_id='info',
        mdfcn_dt=SYSDATETIME,
        cntn_ip='',
        cntn_os='Windows10',
        cntn_login_yn='N';

CREATE OR REPLACE FUNCTION encryptAES256(str varchar) RETURN varchar
AS LANGUAGE JAVA
NAME 'SpTest7.typeteststring(java.lang.String) return java.lang.String';

prepare st from 'update tp_user set
        usr_no=?,
        usr_id=?,
        usr_nm=?,
        dept_cd=?,
        authrt_cd=?,
        usr_eml_addr=(select encryptAES256(?)),
        usr_mbl_telno=?,
        jbps_cd=?,
        jbgd_cd=?,
        wrc_telno=?,
        wrc_fxno=?,
        home_telno=?,
        tkcg_work=?,
        oa_authrt_yn=?,
        dept_head_yn=?,
        brdt=?,
        brdt_se_cd=?,
        dic=(select encryptAES256(?)),
        mdfr_id=?,
        mdfcn_dt=SYSDATETIME,
        cntn_ip=?,
        cntn_os=?,
        cntn_login_yn=?
        where usr_no = ?';


execute st using 123,'info','testnm', '9876543', 'AAA001', 'info@cubrid.com', '010-1234-5678', '0067600', '22244', '01)234-5678', '01)1234-1234', '', 'testwork', 'Y', 'Y', '19000101', '1', 'M20-00001', 'info', '', 'Window10', 'N', 123;

DROP PREPARE st;
DROP FUNCTION encryptAES256;
drop table if exists tp_user;
