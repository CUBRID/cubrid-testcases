create table vwisa (
     that_nk                CHARACTER VARYING(1073741823) NOT NULL,
     that_nk_hash           BIGINT NOT NULL,
     that_nk_cgmapid        INTEGER,
     that_aza_ta            BIGINT,
     that_dhs_ta            BIGINT,
     oahe_vam             BIGINT NOT NULL,
     oahe_fam           BIGINT NOT NULL,
     oahe_vaid          CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_vivhid             CHARACTER VARYING(1073741823) NOT NULL,
     oahe_nbany  CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_p3i         INTEGER DEFAULT 0,
     oahe_bf         CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_bt           CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_et            CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_nn                 CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_lnn                CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_aq            CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_aqwtte        CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_pzv         INTEGER DEFAULT 3,
     oahe_ed         BIGINT DEFAULT 0,
     oahe_aw             BIGINT DEFAULT 0,
     oahe_fsd     DOUBLE NOT NULL,
     oahe_ssd      BIGINT NOT NULL,
     oahe_jd           BIGINT DEFAULT 0,
     oahe_avd   BIGINT DEFAULT 0,
     oahe_aich               BIGINT NOT NULL,
     oahe_baich         BIGINT NOT NULL,
     oahe_wnmt        INTEGER DEFAULT 0,
     oahe_inmt        INTEGER DEFAULT 0,
     oahe_tla         INTEGER DEFAULT 0,
     oahe_bla         INTEGER DEFAULT 0,
     oahe_tid           CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_tjd    BIGINT DEFAULT 0,
     oahe_pdh CHARACTER VARYING(1073741823) DEFAULT '',
     oahe_nnwthujez INTEGER DEFAULT 0,
     oahe_naolnwthujez INTEGER DEFAULT 0,
     oahe_ney1 INTEGER DEFAULT 0,
     oahe_ney2 INTEGER DEFAULT 0,
     oahe_af           SMALLINT DEFAULT 0,
     oahe_fswu               BIGINT DEFAULT 0);


     create index user_pk_vwisa_msn ON vwisa (that_nk_hash, that_nk, oahe_vam);
     create INDEX vwisa_that_nk_cgmapid_that_aza_ta ON vwisa (that_nk_cgmapid, that_aza_ta);
     create INDEX vwisa_that_dhs_ta ON vwisa (that_dhs_ta);
     create INDEX user_idx_vwisa_1 ON vwisa (that_nk_hash, that_nk, oahe_fam, oahe_vam);
     create INDEX user_idx_vwisa_2 ON vwisa (that_nk_hash, that_nk, oahe_tid, oahe_tjd, oahe_vam, oahe_fam);
     create INDEX user_idx_vwisa_3 ON vwisa (that_nk_hash, that_nk, oahe_vaid);
     create INDEX user_idx_vwisa_4 ON vwisa (that_nk_hash, that_nk, oahe_af, oahe_fsd, oahe_fam, oahe_fswu);
     create INDEX user_idx_vwisa_5 ON vwisa (that_nk_hash, that_nk, oahe_fam, oahe_fsd, oahe_vam);
     create INDEX user_idx_vwisa_notin ON vwisa (that_nk_hash, that_nk, oahe_fsd, oahe_vam, oahe_fam);

insert into vwisa values
('nm_test_1',   334406952, 6952,  2680839689,   NULL, 8, 101,  '112',  'MID',  'Subject:test',   0,  'Test1',  'Test2', 'Test3',  '','','This is Subject','', 2,99,   1300,9.900008000000000e+01, 0, 0, 0, 14300, 0,    1,    1, 172, 171,  '102',  1337691543, 'nm_test_1@domainname.com',0,   0, 0, 0, 0, 655904 ),('nm_test_1',   334406952, 6952,  2680856841,   NULL, 9, 101,  '108',  'MID',  'Subject:test',   0,  'Test1',  'Test2', 'Test3',  '','','This is Subject','', 2,99,   1800,9.900009000000000e+01, 0, 0, 0, 12200, 0,    2,    1, 172, 171,  '103',  1337691543, 'nm_test_1@domainname.com',0,   0, 0, 0, 0,    512),('nm_test_1',   334406952, 6952,  2680727561,   NULL, 1, 101,  '100',  'MID',  'Subject:test',   0,  'Test1',  'Test2', 'Test3',  '','','This is Subject','', 1,99,    900,9.900001000000000e+01, 0, 0,  1337691543, 10000, 0,    2,    1, 172, 171,  '100',  1337691543, 'nm_test_1@domainname.com',0,   0, 0, 0, 1,52);

select /*+ recompile */ oahe_fam,oahe_af,oahe_vam from vwisa where (oahe_fam = 101 and ((oahe_vam > 5 and oahe_af = 0) or (oahe_af > 0))) and vwisa.that_nk = 'nm_test_1' and vwisa.that_nk_hash = 334406952 and vwisa.that_dhs_ta is null order by oahe_af ASC,oahe_fsd ASC,oahe_af ASC limit 0,3;

prepare s1 from 'select /*+ recompile */ oahe_fam,oahe_af,oahe_vam from vwisa where (oahe_fam = ? and ((oahe_vam > ? and oahe_af = ?) or (oahe_af > ?))) and vwisa.that_nk = ? and vwisa.that_nk_hash = ? and vwisa.that_dhs_ta is null order by oahe_af ASC,oahe_fsd ASC,oahe_af ASC limit 0,3';

execute s1 using 101, 5, 0, 0, 'nm_test_1', 334406952;
deallocate prepare s1;
drop table vwisa;

