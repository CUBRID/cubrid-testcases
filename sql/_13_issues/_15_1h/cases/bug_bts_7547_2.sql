set optimization level 513;

CREATE CLASS [test_h];
CREATE CLASS [test_d];
CREATE CLASS [test_d_u];
CREATE CLASS [test_p_d];
CREATE CLASS [test_s];
CREATE CLASS [test_b] REUSE_OID;

ALTER CLASS [test_h] ADD ATTRIBUTE
       [c_n] character varying(30) NOT NULL,
       [c1] character varying(30) NOT NULL,
       [t_h_n] character varying(300) NOT NULL,
       [c3] character varying(300) NOT NULL,
       [c4] character varying(300),
       [s_n] character varying(300),
       [c5] character varying(300),
       [c6] character varying(30) NOT NULL,
       [u_i] character varying(300) NOT NULL,
       [c7] character varying(100) NOT NULL,
       [c8] character varying(10) NOT NULL,
       [c9] timestamp NOT NULL;

ALTER CLASS [test_h] ADD ATTRIBUTE
       CONSTRAINT [ipk_test_h] PRIMARY KEY([c_n]);

call [change_owner]('test_h', 'DBA') on class [db_root];
ALTER CLASS [test_d] ADD ATTRIBUTE
       [db_no] integer NOT NULL,
       [svc_no] integer NOT NULL,
       [d_n] character varying(150) NOT NULL,
       [c1] integer,
       [d_c] character varying(1000),
       [in_yn] character(1),
       [in_cd] character varying(5),
       [rr_e_n] character varying(10),
       [r_d] timestamp,
       [m_e_n] character varying(10),
       [m_d] timestamp,
       [c2] character varying(150) NOT NULL;

ALTER CLASS [test_d] ADD ATTRIBUTE
       CONSTRAINT [ipk_test_d] PRIMARY KEY([db_no]);

call [change_owner]('test_d', 'DBA') on class [db_root];
ALTER CLASS [test_d_u] ADD ATTRIBUTE
       [p_db_no] integer NOT NULL,
       [d_u_i] character varying(30) NOT NULL,
       [s_a_yn] character(1) NOT NULL,
       [u_yn] character(1) NOT NULL,
       [in_yn] character(1),
       [in_cd] character varying(5),
       [r_d] timestamp NOT NULL,
       [rr_e_n] character varying(10) NOT NULL,
       [m_e_n] character varying(10),
       [m_d] timestamp;

ALTER CLASS [test_d_u] ADD ATTRIBUTE
       CONSTRAINT [pk_test_d_u_p_db_no_d_u_i] PRIMARY KEY([p_db_no], [d_u_i]);

call [change_owner]('test_d_u', 'DBA') on class [db_root];
ALTER CLASS [test_p_d] ADD ATTRIBUTE
       [p_db_no] integer NOT NULL,
       [db_no] integer NOT NULL,
       [db_alas] character varying(150),
       [p_d_n] character varying(150),
       [s_a_yn] character(1),
       [d_a_u] character(1),
       [s_r_t] character varying(5) NOT NULL,
       [d_r_t] character varying(5),
       [c_t] character varying(5),
       [c1] character varying(100),
       [i_n] character varying(150),
       [c_p] integer,
       [c2] character varying(1000),
       [rr_e_n] character varying(10),
       [r_d] timestamp,
       [m_e_n] character varying(10),
       [m_d] timestamp,
       [c_n] character varying(30) NOT NULL,
       [ch_n] character varying(30),
       [s_v] character varying(23),
       [o_s_nm] character varying(30),
       [s_n] character varying(30);

ALTER CLASS [test_p_d] ADD ATTRIBUTE
       CONSTRAINT [pk_test_p_test_p_d_no] PRIMARY KEY([p_db_no]);

call [change_owner]('test_p_d', 'DBA') on class [db_root];
ALTER CLASS [test_s] ADD ATTRIBUTE
       [svc_no] integer NOT NULL,
       [u_s_n] integer,
       [s_n] character varying(150) NOT NULL,
       [u_s] character(1),
       [d_t] character varying(5),
       [e_n] integer,
       [d_c] character varying(2000),
       [u_yn] character(1),
       [rr_e_n] character varying(10) NOT NULL,
       [r_d] timestamp NOT NULL,
       [m_e_n] character varying(10),
       [m_d] timestamp,
       [q_s_m] character(1) DEFAULT 'N',
       [m_a_yn] character(1) DEFAULT 'N' NOT NULL;

ALTER CLASS [test_s] ADD ATTRIBUTE
       CONSTRAINT [ipk_test_s] PRIMARY KEY([svc_no]);

call [change_owner]('test_s', 'DBA') on class [db_root];
ALTER CLASS [test_b] ADD ATTRIBUTE
       [p_db_no] integer NOT NULL,
       [b_svr_c_n] character varying(30) NOT NULL,
       [c_p] integer NOT NULL,
       [b_u_t] character varying(5) NOT NULL,
       [c1] character varying(5),
       [b_nm] character varying(150) NOT NULL,
       [s_v] character varying(23),
       [b_d_c] character varying(1000),
       [rr_e_n] character varying(10),
       [r_d] timestamp,
       [m_e_n] character varying(10),
       [m_d] timestamp;

ALTER CLASS [test_b] ADD ATTRIBUTE
       CONSTRAINT [ipk_test_b] PRIMARY KEY([p_db_no], [b_svr_c_n], [c_p]);

call [change_owner]('test_b', 'DBA') on class [db_root];

--db_indexes
CREATE INDEX [ink01_test_d] ON [test_d] ([svc_no]);
CREATE INDEX [idx1_test_p_d] ON [test_p_d] ([db_no]);
CREATE INDEX [idx2_test_p_d] ON [test_p_d] ([c_n]);
CREATE INDEX [ink01_test_s] ON [test_s] ([s_n]);

--query
SELECT /*+ recompile ordered */ service.svc_no,service.s_n,service.d_t,logicaldb.DB_NO,logicaldb.d_n,physicaldb.P_DB_NO,physicaldb.P_d_n,
       physicaldb.DB_ALAS,physicaldb.i_n,physicaldb.c_p,physicaldb.ch_n,test_h.c_n,test_h.t_h_n,
       IF(physicaldb.s_v IS NULL OR physicaldb.s_v = '', test_h.u_i, physicaldb.s_v) AS u_i,dbuser.d_u_i,
       dbuser.IN_YN, dbuser.IN_CD              
FROM   test_s service
INNER JOIN test_d logicaldb ON service.svc_no = logicaldb.svc_no
INNER JOIN test_p_d physicaldb ON logicaldb.DB_NO = physicaldb.DB_NO
INNER JOIN test_h test_h ON physicaldb.c_n = test_h.c_n 
INNER JOIN test_d_u dbuser ON physicaldb.p_DB_NO = dbuser.p_DB_NO
LEFT OUTER JOIN (SELECT P_DB_NO, COUNT(*) AS brokerCount 
                 FROM test_b 
                 WHERE b_u_t = '02' 
                 GROUP BY P_DB_NO) bfa ON physicaldb.P_DB_NO = bfa.P_DB_NO
WHERE 1=1
AND service.u_s = 'Y'
AND physicaldb.d_a_u = 'Y'
AND DECODE(service.d_t, 'CUBRI', bfa.brokerCount, 1) IS NOT NULL 
AND service.svc_no = 556 
AND UPPER(test_h.t_h_n) LIKE '%' || UPPER('mdb401.kin') || '%' 
ORDER BY service.s_n, service.svc_no, logicaldb.d_n, logicaldb.DB_NO, physicaldb.DB_ALAS, physicaldb.P_DB_NO, dbuser.d_u_i ;

drop table [test_h],[test_d],[test_d_u],[test_p_d],[test_s],[test_b];
