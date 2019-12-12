--Test vclass using object alteration


CREATE CLASS that01;
ALTER CLASS that01 ADD ATTRIBUTE
       njs1 character(10) NOT NULL,
       bu_that21 character(1) NOT NULL,
       nswaa_nthat character(2),
       qbwk_that character(1) NOT NULL,
       swat_n_that character(8),
       lie_that character(8),
       zwmu_h_that character(1),
       ahx character(1),
       ipbwk_that character varying(2) NOT NULL,
       izok_zthat character(1),
       izok_uthat character varying(2),
       nswaa_uthat character(1) NOT NULL,
       niensh_nthat character(2) NOT NULL,
       bu_that2 character(10) NOT NULL,
       opdwth_dt timestamp NOT NULL,
       opdwth_that character varying(20) NOT NULL,
       nswaa_mthat character varying(30),
       bwk_that character varying(50) NOT NULL,
       bbwk_that character varying(50),
       qv_mthat character varying(30) NOT NULL,
       hmu_bwk_that character varying(50),
       liuj_that character varying(3000),
       uewdh character varying(2),
       bqok_nthat character(2) NOT NULL,
       ehws_uthat character varying(2);

create UNIQUE index that01_pk on that01(njs1, bu_that21);
create INDEX that01_x2 ON that01(bu_that21,uewdh,nswaa_nthat,njs1);

CREATE VCLASS test02;
ALTER VCLASS test02 ADD ATTRIBUTE
njs1					CHARACTER(10),
bu_that2					CHARACTER(10),
gy_gtest				CHARACTER(2),
gy_ctest				CHARACTER(2),
uewdh					CHARACTER VARYING(2),
hg_ctest				CHARACTER(4),
sjg_test				CHARACTER VARYING(20),
bjg_test			CHARACTER VARYING(20),
bjgg_test				CHARACTER VARYING(20),
nswaa_nthat				CHARACTER(2),
juya_ctest				CHARACTER(1),
nswaa_mthat				CHARACTER VARYING(30),
qbwk_that				CHARACTER(1),
bqok_nthat			CHARACTER(2),
swat_n_that				CHARACTER(8),
bwk_that					CHARACTER VARYING(50),
bbwk_that				CHARACTER VARYING(50),
qv_mthat				CHARACTER VARYING(30),
zwmu_h_that				CHARACTER(1),
lie_that				CHARACTER(8),
ahx					CHARACTER(1),
ipbwk_that				CHARACTER VARYING(2),
study_test				CHARACTER VARYING(2),
izok_zthat				CHARACTER(1),
izok_uthat				CHARACTER VARYING(2),
opdwth_dt				TIMESTAMP,	
opdwth_that				CHARACTER VARYING(20);

ALTER VCLASS test02 ADD QUERY SELECT 
njs1,                          
bu_that2,                           
'06',                   
'',                        
ehws_uthat,                          
'0685',                            
'',                        
'',                    
'',                       
nswaa_nthat,                        
'1',                             
nswaa_mthat,                        
qbwk_that,                       
bqok_nthat,                
swat_n_that,                  
bwk_that,                          
bbwk_that,                                 
qv_mthat,                        
zwmu_h_that,                     
lie_that,                        
ahx,                             
ipbwk_that,                        
'',                            
izok_zthat,                       
izok_uthat,                    
opdwth_dt,                       
opdwth_that 
FROM that01
WHERE bu_that21 = '4';

INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,
nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,
ehws_uthat ) values (
'2006000008','4','01','1','20060302','','1','2','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','7z3mXnXSWW0Yos4dgUjBAQ==','LIWdtEPiEmuPv1kvFLELiA==','','XsyaWSD7ULboAFxJaTUzcQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000006','4','01','1','20060302','19990202','1','2','99','Y','3','1','01','B100000680',timestamp'21:58:41 PM 05/01/2006','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','mNPIEAeOvtFXKEROyz8GBw==','','e8hc7dFyVP5NQyFhl460xg==','','','3','01','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000031','4','02','1','20050301','','1','1','99','N','7','1','01','B100000680',timestamp'18:47:57 PM 11/04/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','yjlCzwtJCZUOMOVhas09Zw==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'7','01','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000032','4','02','1','20050301','','1','2','99','N','7','1','01','B100000680',timestamp'18:47:57 PM 11/04/2005','9910011000000','ys2vY5RcUR1480A23OybHg==','SGl7qUcwyBuK99sb+2A1Ww==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'7','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000002','4','01','1','20050301','','1','1','99','N','1','1','01','B100000680',timestamp'19:41:40 PM 11/03/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','xe2Q9J/XvJcf7UWGVvU6NA==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000001','4','01','1','20050301','','1','2','99','N','1','1','01','B100000680',timestamp'19:41:40 PM 11/03/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','0HoeFLA87LaKLncGHzjJpw==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000003','4','01','1','20050301','','1','2','99','N','1','1','01','B100000680',timestamp'19:41:40 PM 11/03/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','DtKKWQ2UDM9ttCDkv3I38w==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000004','4','01','1','20050301','','1','1','99','N','1','1','01','B100000680',timestamp'19:41:40 PM 11/03/2005','9910011000000','ys2vY5RcUR1480A23OybHg==','UCFbVJ3fUgScuEvLrwjxSA==','','wY86rx4b3MZA+gErJ1ubtA==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000006','4','02','1','20050301','','1','1','99','N','1','1','01','B100000680',timestamp'19:42:58 PM 11/03/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','mkM6WdI5pf2MBqCoAqSdzw==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000005','4','02','1','20050301','','1','2','99','N','1','1','01','B100000680',timestamp'19:42:58 PM 11/03/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','5Tb5vHiS1yLwM3XY/ZKA/w==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000007','4','02','1','20050301','','1','2','99','N','1','1','01','B100000680',timestamp'19:42:58 PM 11/03/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','Bh8+bZdfJ1eZd2tAtI+CrQ==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000008','4','02','1','20050301','','1','1','99','N','1','1','01','B100000680',timestamp'19:42:58 PM 11/03/2005','9910011000000','ys2vY5RcUR1480A23OybHg==','NwGHRThs5n2nTBqF7SW+yA==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000009','4','01','1','20050301','','1','2','99','N','7','1','01','B100000680',timestamp'19:44:28 PM 11/03/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','dSzMnTKRYMRzj3pcgCa8yA==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'7','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000010','4','01','1','20040301','','1','1','99','N','7','1','01','B100000680',timestamp'19:44:28 PM 11/03/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','haPl/fHbM+cyi39cvSraAg==','','wY86rx4b3MZA+gErJ1ubtA==','',NULL,'7','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000011','4','01','1','20030301','','1','2','99','N','7','1','01','B100000680',timestamp'19:44:28 PM 11/03/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','Lz7biWn9xcqxqgrVx4MfCw==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'7','01','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000019','4','02','1','20040301','','1','1','99','N','2','1','01','B100000680',timestamp'19:07:20 PM 11/04/2005','9910011000000','ys2vY5RcUR1480A23OybHg==','jmk6xaSFIUmSdhROIyukMA==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000022','4','01','2','20060215','','1','1','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','8gUVKgNJrYzfYNv3E3/6kg==','uAVzbB2F/PwAxYcfsJ91/g==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000021','4','01','2','20060215','','1','2','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','xz6iE68b0ltnc5Pf/6cv0w==','0Nizmmju+yDCugr4EnIiTg==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000023','4','01','2','20060215','','1','1','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','yLGMSeeCxfKaHBgQk5Plag==','Xu41mKUUc9Y0K2jDhUWFtw==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000024','4','01','2','20060215','','1','2','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','ys2vY5RcUR1480A23OybHg==','MHZGHM/xIuftauRv7BobfA==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000026','4','02','2','20060215','','1','1','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','8gUVKgNJrYzfYNv3E3/6kg==','3bcdZ0QU4OoIgxM/neB09g==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000025','4','02','2','20060215','','1','1','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','xz6iE68b0ltnc5Pf/6cv0w==','0Nizmmju+yDCugr4EnIiTg==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000027','4','02','2','20060215','','1','1','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','yLGMSeeCxfKaHBgQk5Plag==','gh8TK9N7jJzERpg6o+JYcQ==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000028','4','02','2','20060215','','1','2','99','N','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','ys2vY5RcUR1480A23OybHg==','5DXMTmspuTvkCKNCg9UbDA==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'3','18','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000029','4','02','1','20050301','','1','2','99','N','7','1','01','B100000680',timestamp'18:47:57 PM 11/04/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','L6BJwNzXbay1vFE8VPfU5A==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'7','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000030','4','02','1','20050301','','1','1','99','N','7','1','01','B100000680',timestamp'18:47:57 PM 11/04/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','lW5rgfyDR3m0AA21pPfkPg==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'7','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000012','4','01','1','20040301','','1','1','99','N','2','1','01','B100000680',timestamp'19:05:46 PM 11/04/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','KMTxWan/O81uWrOUMTMZ/A==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000013','4','01','1','20040301','','1','2','99','N','2','1','01','B100000680',timestamp'19:06:00 PM 11/04/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','P4zDcX6uIUDOkn7XeAYcew==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000015','4','01','1','20040301','','1','2','99','N','2','1','01','B100000680',timestamp'19:06:13 PM 11/04/2005','9910011000000','ys2vY5RcUR1480A23OybHg==','cy1c8D1S2RlvyEz71UBy/w==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000016','4','01','1','20040301','','1','2','99','N','2','1','01','B100000680',timestamp'19:05:32 PM 11/04/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','VjU1gcq1pFv0hoyZZAE3uQ==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000018','4','02','1','20040301','','1','1','99','N','2','1','01','B100000680',timestamp'19:06:45 PM 11/04/2005','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','XJPOlbvunEtAIyrUz47bGA==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000017','4','02','1','20040301','','1','2','99','N','2','1','01','B100000680',timestamp'19:06:32 PM 11/04/2005','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','PwGsb8iumB4zfjqhivsf/Q==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000020','4','02','1','20040301','','1','1','99','N','2','1','01','B100000680',timestamp'19:06:56 PM 11/04/2005','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','VKG2LCu0SAhEluISKgT0kg==','','b7a4pTBbVOdeVL6h10xNgA==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000003','4','01','1','20060302','','1','1','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','yLGMSeeCxfKaHBgQk5Plag==','SEAApaq33HLBvqakBRV0YA==','','Z/iT5L5rSInbiZeN0T3DYQ==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000004','4','01','1','20060302','','1','2','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','ys2vY5RcUR1480A23OybHg==','gTms/MoOcTynaVBQrCgZjQ==','','5cFDJzVxys9t+EF6Rho34Q==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000005','4','01','1','20060302','','1','1','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','LHfobt2W8+0jJVL/mBACTw==','DGviZZPfrJra1w0hR1y+xg==','','8/MAJApMyIO6YjjNN8Gokg==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000007','4','01','1','20060302','','1','1','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','PYHaamHCC8h5b9fUmCFMww==','hVLSb3aUsTmTxSkxBvQx7w==','','3GwQGY6COBBBCHmz7NFFZw==','',NULL,'1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2005000033','4','01','1','20060317','','1','1','99','Y','3','1','01','B100000680',timestamp'10:27:13 AM 02/09/2006','066501','h9FHBQHeundsMI1/Asaq1A==','333sBznHXQyBQnOW1B6Axw==','','nE9gxR8QXKeHFDSknNKObw==','',NULL,'1','06','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000002','4','01','1','20030304','19990101',NULL,'2','01','N',NULL,'1','01','B100000680',timestamp'17:12:40 PM 05/01/2006','9910011000000','8gUVKgNJrYzfYNv3E3/6kg==','PkoJJYX2ZKwvLH7EvXQsMg==','','mCWlO6g02DSOISH2tLLyoQ==',NULL,'','1','01','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000009','4','01','1','20060321','','1','2','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','pqRPXAgcw3EDZYU2gC1J9A==','l7gxTGqlRhQpkF0t/H8JZg==','','kBEFmuBDunZ3wuLMEOnDKQ==','',NULL,'1','04','1' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000010','4','01','1','20060320','19990202','1','2','99','Y','3','1','01','B100000680',timestamp'21:58:23 PM 05/01/2006','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','we19iUioyIsFZOTqEh7WGA==','','WzEn4wlP1X3bF2P2K4859w==','','','3','01','3' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000013','4','01','1','20060303','','1','2','99','Y','2','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','NzVGf+D+ecOU6bx4jQzVRQ==','','7mNwxtHUCEw6jvZsZbrdzA==','',NULL,'2','01','2' ) ;
INSERT INTO that01 (njs1,bu_that21,nswaa_nthat,qbwk_that,swat_n_that,lie_that,zwmu_h_that,AHX,ipbwk_that,izok_zthat,izok_uthat,nswaa_uthat,niensh_nthat,bu_that2,OPDWTH_DT,opdwth_that,nswaa_mthat,bwk_that,bbwk_that,qv_mthat,HMU_bwk_that,liuj_that,UEWDH,bqok_nthat,ehws_uthat ) values ('2006000001','4','01','1','20060302','','1','1','99','Y','1','1','01','B100000680',timestamp'17:31:48 PM 05/01/2006','9910011000000','xz6iE68b0ltnc5Pf/6cv0w==','333sBznHXQyBQnOW1B6Axw==','','nE9gxR8QXKeHFDSknNKObw==','',NULL,'1','01','1' ) ;

 SELECT * 
    FROM (
         SELECT a.juya_ctest, a.hg_ctest
         FROM    test02 a
         WHERE   A.bu_that2 = 'B100000680'
                    AND    A.UEWDH = '3'
                    AND    A.qbwk_that = '1'
        )LEVEL1;

 SELECT * 
    FROM (
         SELECT  trim(a.juya_ctest) juya_ctest, trim(a.hg_ctest) hg_ctest
         FROM    test02 a
         WHERE   A.bu_that2 = 'B100000680'
                    AND    A.UEWDH = '3'
                    AND    A.qbwk_that = '1'
        )LEVEL1;

SELECT a.juya_ctest, a.hg_ctest
         FROM    test02 a
         WHERE   A.bu_that2 = 'B100000680'
                    AND    A.UEWDH = '3'
                    AND    A.qbwk_that = '1';



drop table that01;
drop view test02;
