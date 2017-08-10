--Test alter class and vclass using add attribute and add query and change query

CREATE CLASS that01;
ALTER CLASS that01 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       uewdh character varying(2) NOT NULL,
       uewdh_ytest character(4) NOT NULL,
       qbk_that character(1) NOT NULL,
       bl_that character(10) NOT NULL,
       nbh_u_that character varying(2) NOT NULL,
       sb_nbh_u_that character varying(4) NOT NULL,
       n_that character varying(2) NOT NULL,
       bk_that character(1) NOT NULL,
       ahr integer DEFAULT 1,
       htn_that1 character varying(100),
       htn_that2 character varying(100),
       htn_that3 character varying(100),
       opdwth_dt timestamp,
       opdwth_that character varying(20);

ALTER CLASS that01 ADD ATTRIBUTE
       CONSTRAINT that01_pk UNIQUE(bu_that, uewdh, uewdh_ytest, qbk_that, bl_that, nbh_u_that, sb_nbh_u_that, n_that, bk_that, ahr);


CREATE CLASS that02;
ALTER CLASS that02 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       bl_that character(10) NOT NULL,
       lhf_ipbwk_that character varying(1000),
       ahx character(1),
       qoaj_that character varying(1000),
       fw_lthat character(8),
       vj_lthat character(8),
       fwv_that character varying(1000),
       bk_aphn_that character varying(1000),
       njoeah_that character varying(3),
       opdwth_that character varying(20) NOT NULL,
       opdwth_dt timestamp,
       qs_that character varying(16),
       hmu_bwk_that character varying(50),
       bwk_that character varying(50) NOT NULL,
       hj_bwk_that character varying(50),
       qo_that character varying(30) NOT NULL,
       fw_mthat character varying(30),
       vj_mthat character varying(30);
ALTER CLASS that02 ADD ATTRIBUTE
       CONSTRAINT that02_pk UNIQUE(bl_that);

CREATE CLASS that03;
ALTER CLASS that03 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       bl_that character(10) NOT NULL,
       uewdh character varying(2) NOT NULL,
       u_ahr_test integer NOT NULL,
       uewdh_ytest character(4) NOT NULL,
       nu_uthat character varying(12),
       nu_mthat character varying(100),
       iao_thattivh integer,
       aphn_dthat character varying(3000),
       opdwth_that character varying(20) NOT NULL,
       opdwth_dt timestamp;

ALTER CLASS that03 ADD ATTRIBUTE
       CONSTRAINT that03_pk UNIQUE(bl_that, uewdh, u_ahr_test, uewdh_ytest);

CREATE CLASS that04;
ALTER CLASS that04 ADD ATTRIBUTE
       bu_that character(10) NOT NULL,
       bl_that character(10) NOT NULL,
       uewdh_ytest character(4) NOT NULL,
       uewdh character varying(2) NOT NULL,
       nswaa_nthat character(2) NOT NULL,
       qbk_that character(1),
       bwkqok_nbwmuh_that character varying(2),
       opdwth_dt timestamp,
       opdwth_that character varying(20) NOT NULL,
       nswaa_mthat character varying(30) NOT NULL;

ALTER CLASS that04 ADD ATTRIBUTE
       CONSTRAINT that04_pk UNIQUE(bl_that, uewdh_ytest);
CREATE VCLASS test05;
 ALTER VCLASS test05 ADD ATTRIBUTE
       bu_that character(10),
       uewdh_ytest character(4),
       uewdh character varying(2),
       bl_that character(10);

ALTER VCLASS test05 ADD QUERY 
select NA,NA,NA,NA from that04 that04 where that04.qbk_that='2' and (that04.bwkqok_nbwmuh_that<'17' or that04.bwkqok_nbwmuh_that>'19') ;

ALTER VCLASS test05 CHANGE QUERY 1 select that04.bu_that, that04.uewdh_ytest, that04.UEWDH, that04.bl_that 
from that04 that04 where that04.qbk_that='2' and 
(that04.bwkqok_nbwmuh_that<'17' or that04.bwkqok_nbwmuh_that>'19') ;

SELECT /*+ ORDERED USE_IDX */ DISTINCT
                   C.bu_that,
                   C.UEWDH,
                   C.uewdh_ytest,
                   C.bl_that,
                   '3',
                   '08',
                   '0801',
                   D.UEWDH,
                           '0',
                   '14:24:00 05/26/2008',
                   '9910011000000'
   FROM   test05 C,
          that02 A,
          that03 D
   WHERE  C.bl_that         = A.bl_that
   AND    C.bl_that         = D.bl_that
   AND    C.uewdh_ytest     = '2002'
   AND    C.UEWDH          = '1'
   AND   ((C.uewdh_ytest = '2005'                                      )
         OR    (C.uewdh_ytest = '2004' AND C.UEWDH  = '6' AND D.UEWDH >= '2')
         OR    (C.uewdh_ytest = '2004' AND C.UEWDH <= '5'                   )
         OR    (C.uewdh_ytest = '2003' AND C.UEWDH  = '6' AND D.UEWDH >= '4')
         OR    (C.uewdh_ytest = '2003' AND C.UEWDH  = '5' AND D.UEWDH >= '2')
         OR    (C.uewdh_ytest = '2003' AND C.UEWDH <= '4'                   ))
   AND   ( Rtrim(D.nu_mthat) = '' OR D.nu_mthat IS NULL
    OR     D.iao_thattivh    IS NULL
    OR     D.iao_thattivh    < 1
         );

drop that01,that02,that03,that04,test05;
