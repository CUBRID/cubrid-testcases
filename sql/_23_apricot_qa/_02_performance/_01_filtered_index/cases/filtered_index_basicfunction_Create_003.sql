-+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(
  a char(1200) not null, 
  b varchar(1200),
  c nchar(1200),
  d NCHAR VARYING(1200),
  e BIT(1200),
  f BIT VARYING(1200),
  g int,
  h SMALLINT,
  i BIGINT,
  j NUMERIC,
  k FLOAT,
  l DOUBLE,
  m MONETARY,
  n DATE,
  o TIME,
  p TIMESTAMP,
  q DATETIME
);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
--test create index successfully
create index i_t1_a_1 on t1(a) where a>'1234';
drop index i_t1_a_1 on t1;
--test create index successfully
create index i_t1_a_2 on t1(a) where a is not null;
drop index i_t1_a_2 on t1;
--test create index failed
create index i_t1_a_3 on t1(a) where a like '12345%';
drop index i_t1_a_3 on t1;
--test create index failed
create index i_t1_a_4 on t1(a) where a in ('1234567890', '00000000');
drop index i_t1_a_4 on t1;
--test create index successfully, because of cbrd-23731 (modified the MAX_FILTER_PREDICATE_STRING_LENGTH is 128 -> 255)
create index i_t1_a_5 on t1(a) where a = any {'00000000','00000002', '11111111'};
drop index i_t1_a_5 on t1;
--test create index failed
create index i_t1_a_6 on t1(a) where a = all {'00000000'};
drop index i_t1_a_6 on t1;
--test create index failed
create index i_t1_a_7 on t1(a) where a = some {'00000000'};
drop index i_t1_a_7 on t1;


--test create index successfully
create index i_t1_b_1 on t1(a) where b>'1234';
drop index i_t1_b_1 on t1;
--test create index successfully
create index i_t1_b_2 on t1(a) where b is not null;
drop index i_t1_b_2 on t1;
--test create index failed
create index i_t1_b_3 on t1(a) where b like '12345%';
drop index i_t1_b_3 on t1;
--test create index failed
create index i_t1_b_4 on t1(a) where b in ('1234567890', '00000000');
drop index i_t1_b_4 on t1;
--test create index successfully, because of cbrd-23731 (modified the MAX_FILTER_PREDICATE_STRING_LENGTH is 128 -> 255)
create index i_t1_b_5 on t1(a) where b = any {'00000000','00000002', '11111111'};
drop index i_t1_b_5 on t1;
--test create index failed
create index i_t1_b_6 on t1(a) where b = all {'00000000'};
drop index i_t1_b_6 on t1;
--test create index failed
create index i_t1_b_7 on t1(a) where b = some {'00000000'};
drop index i_t1_b_7 on t1;

--test create index successfully
create index i_t1_c_1 on t1(a) where c > N'1234';
drop index i_t1_c_1 on t1;
--test create index successfully
create index i_t1_c_2 on t1(a) where c is not null;
drop index i_t1_c_2 on t1;
--test create index failed
create index i_t1_c_3 on t1(a) where c like N'12345%';
drop index i_t1_c_3 on t1;
--test create index failed
create index i_t1_c_4 on t1(a) where c in (N'1234567890', N'00000000');
drop index i_t1_c_4 on t1;
--test create index failed
create index i_t1_c_5 on t1(a) where c = any {N'00000000',N'00000002', N'11111111'};
drop index i_t1_c_5 on t1;
--test create index failed
create index i_t1_c_6 on t1(a) where c = all {N'00000000'};
drop index i_t1_c_6 on t1;
--test create index failed
create index i_t1_c_7 on t1(a) where c = some {N'00000000'};
drop index i_t1_c_7 on t1;

--test create index successfully
create index i_t1_d_1 on t1(a) where d > N'1234';
drop index i_t1_d_1 on t1;
--test create index successfully
create index i_t1_d_2 on t1(a) where d is not null;
drop index i_t1_d_2 on t1;
--test create index failed
create index i_t1_d_3 on t1(a) where d like N'12345%';
drop index i_t1_d_3 on t1;
--test create index failed
create index i_t1_d_4 on t1(a) where d in (N'1234567890', N'00000000');
drop index i_t1_d_4 on t1;
--test create index failed
create index i_t1_d_5 on t1(a) where d = any {N'00000000',N'00000002', N'11111111'};
drop index i_t1_d_5 on t1;
--test create index failed
create index i_t1_d_6 on t1(a) where d = all {N'00000000'};
drop index i_t1_d_6 on t1;
--test create index failed
create index i_t1_d_7 on t1(a) where d = some {N'00000000'};
drop index i_t1_d_7 on t1;

--test create index successfully
create index i_t1_e_1 on t1(a) where e > B'1111';
drop index i_t1_e_1 on t1;
--test create index successfully
create index i_t1_e_2 on t1(a) where e is not null;
drop index i_t1_e_2 on t1;
--test create index failed
create index i_t1_e_3 on t1(a) where e like '1111%';
drop index i_t1_e_3 on t1;
--test create index failed
create index i_t1_e_4 on t1(a) where e in ('11111', '00000000');
drop index i_t1_e_4 on t1;
--test create index failed
create index i_t1_e_5 on t1(a) where e = any {'00000000','00000001', '11111111'};
drop index i_t1_e_5 on t1;
--test create index failed
create index i_t1_e_6 on t1(a) where e = all {'00000000'};
drop index i_t1_e_6 on t1;
--test create index failed
create index i_t1_e_7 on t1(a) where e = some {'00000000'};
drop index i_t1_e_7 on t1;

--test create index successfully
create index i_t1_f_1 on t1(a) where f > B'1111';
drop index i_t1_f_1 on t1;
--test create index successfully
create index i_t1_f_2 on t1(a) where f is not null;
drop index i_t1_f_2 on t1;
--test create index failed
create index i_t1_f_3 on t1(a) where f like '1111%';
drop index i_t1_f_3 on t1;
--test create index failed
create index i_t1_f_4 on t1(a) where f in ('11111', '00000000');
drop index i_t1_f_4 on t1;
--test create index failed
create index i_t1_f_5 on t1(a) where f = any {'00000000','00000001', '11111111'};
drop index i_t1_f_5 on t1;
--test create index failed
create index i_t1_f_6 on t1(a) where f = all {'00000000'};
drop index i_t1_f_6 on t1;
--test create index failed
create index i_t1_f_7 on t1(a) where f = some {'00000000'};
drop index i_t1_f_7 on t1;

--test create index successfully
create index i_t1_g_1 on t1(a) where g > 10;
drop index i_t1_g_1 on t1;
--test create index successfully
create index i_t1_g_2 on t1(a) where g is not null;
drop index i_t1_g_2 on t1;
--test create index failed
--create index i_t1_g_3 on t1(a) where g like 10%;
--drop index i_t1_g_3;
--test create index failed
create index i_t1_g_4 on t1(a) where g in (10, 11);
drop index i_t1_g_4 on t1;
--test create index failed
create index i_t1_g_5 on t1(a) where g = any {10,11,12};
drop index i_t1_g_5 on t1;
--test create index failed
create index i_t1_g_6 on t1(a) where g = all {10};
drop index i_t1_g_6 on t1;
--test create index failed
create index i_t1_g_7 on t1(a) where g = some {11,10};
drop index i_t1_g_7 on t1;

--test create index successfully
create index i_t1_h_1 on t1(a) where h > 10;
drop index i_t1_h_1 on t1;
--test create index successfully
create index i_t1_h_2 on t1(a) where h is not null;
drop index i_t1_h_2 on t1;
--test create index failed
--create index i_t1_h_3 on t1(a) where h like 10%;
--drop index i_t1_h_3;
--test create index failed
create index i_t1_h_4 on t1(a) where h in (10, 11);
drop index i_t1_h_4 on t1;
--test create index failed
create index i_t1_h_5 on t1(a) where h = any {10,11,12};
drop index i_t1_h_5 on t1;
--test create index failed
create index i_t1_h_6 on t1(a) where h = all {10};
drop index i_t1_h_6 on t1;
--test create index failed
create index i_t1_h_7 on t1(a) where h = some {11,10};
drop index i_t1_h_7 on t1;

--test create index successfully
create index i_t1_i_1 on t1(a) where i > 10;
drop index i_t1_i_1 on t1;
--test create index successfully
create index i_t1_i_2 on t1(a) where i is not null;
drop index i_t1_i_2 on t1;
--test create index failed
--create index i_t1_i_3 on t1(a) where i like 10%;
--drop index i_t1_i_3;
--test create index failed
create index i_t1_i_4 on t1(a) where i in (10, 11);
drop index i_t1_i_4 on t1;
--test create index failed
create index i_t1_i_5 on t1(a) where i = any {10,11,12};
drop index i_t1_i_5 on t1;
--test create index failed
create index i_t1_i_6 on t1(a) where i = all {10};
drop index i_t1_i_6 on t1;
--test create index failed
create index i_t1_i_7 on t1(a) where i = some {11,10};
drop index i_t1_i_7 on t1;

--test create index successfully
create index i_t1_j_1 on t1(a) where j > 0;
drop index i_t1_j_1 on t1;
--test create index successfully
create index i_t1_j_2 on t1(a) where j is not null;
drop index i_t1_j_2 on t1;
--test create index failed
--create index i_t1_j_3 on t1(a) where j like 0%;
--drop index i_t1_j_3;
--test create index failed
create index i_t1_j_4 on t1(a) where j in (0, 1);
drop index i_t1_j_4 on t1;
--test create index failed
create index i_t1_j_5 on t1(a) where j = any {0,1};
drop index i_t1_j_5 on t1;
--test create index failed
create index i_t1_j_6 on t1(a) where j = all {0};
drop index i_t1_j_6 on t1;
--test create index failed
create index i_t1_j_7 on t1(a) where j = some {1,0};
drop index i_t1_j_7 on t1;

--test create index successfully
create index i_t1_k_1 on t1(a) where k > 0;
drop index i_t1_k_1 on t1;
--test create index successfully
create index i_t1_k_2 on t1(a) where k is not null;
drop index i_t1_k_2 on t1;
--test create index failed
--create index i_t1_k_3 on t1(a) where k like 0%;
--drop index i_t1_k_3;
--test create index failed
create index i_t1_k_4 on t1(a) where k in (0, 1);
drop index i_t1_k_4 on t1;
--test create index failed
create index i_t1_k_5 on t1(a) where k = any {0,1};
drop index i_t1_k_5 on t1;
--test create index failed
create index i_t1_k_6 on t1(a) where k = all {0};
drop index i_t1_k_6 on t1;
--test create index failed
create index i_t1_k_7 on t1(a) where k = some {1,0};
drop index i_t1_k_7 on t1;

--test create index successfully
create index i_t1_l_1 on t1(a) where l > 0;
drop index i_t1_l_1 on t1;
--test create index successfully
create index i_t1_l_2 on t1(a) where l is not null;
drop index i_t1_l_2 on t1;
--test create index failed
--create index i_t1_l_3 on t1(a) where l like 0%;
--drop index i_t1_l_3;
--test create index failed
create index i_t1_l_4 on t1(a) where l in (0, 1);
drop index i_t1_l_4 on t1;
--test create index failed
create index i_t1_l_5 on t1(a) where l = any {0,1};
drop index i_t1_l_5 on t1;
--test create index failed
create index i_t1_l_6 on t1(a) where l = all {0};
drop index i_t1_l_6 on t1;
--test create index failed
create index i_t1_l_7 on t1(a) where l = some {1,0};
drop index i_t1_l_7 on t1;


--test create index successfully
create index i_t1_m_1 on t1(a) where m >-100;
drop index i_t1_m_1 on t1;
--test create index successfully
create index i_t1_m_2 on t1(a) where m is not null;
drop index i_t1_m_2 on t1;
--test create index failed
--create index i_t1_m_3 on t1(a) where m like -10%;
--drop index i_t1_m_3;
--test create index failed
create index i_t1_m_4 on t1(a) where m in (0, -100);
drop index i_t1_m_4 on t1;
--test create index failed
create index i_t1_m_5 on t1(a) where m = any {0,-100};
drop index i_t1_m_5 on t1;
--test create index failed
create index i_t1_m_6 on t1(a) where m = all {-100};
drop index i_t1_m_6 on t1;
--test create index failed
create index i_t1_m_7 on t1(a) where m = some {-100,0};
drop index i_t1_m_7 on t1;


--test create index successfully
create index i_t1_n_1 on t1(a) where n > '2008-10-31';
drop index i_t1_n_1 on t1;
--test create index successfully
create index i_t1_n_2 on t1(a) where n is not null;
drop index i_t1_n_2 on t1;
--test create index failed
create index i_t1_n_3 on t1(a) where n like '2008-10-%';
drop index i_t1_n_3 on t1;
--test create index failed
create index i_t1_n_4 on t1(a) where n in ('2008-10-31', '2008-10-30');
drop index i_t1_n_4 on t1;
--test create index failed
create index i_t1_n_5 on t1(a) where n = any {'2008-10-31', '2008-10-30'};
drop index i_t1_n_5 on t1;
--test create index failed
create index i_t1_n_6 on t1(a) where n = all {'2008-10-31'};
drop index i_t1_n_6 on t1;
--test create index failed
create index i_t1_n_7 on t1(a) where n = some {'2008-10-31', '2008-10-30'};
drop index i_t1_n_7 on t1;



--test create index successfully
create index i_t1_o_1 on t1(a) where o > '00:00:00';
drop index i_t1_o_1 on t1;
--test create index successfully
create index i_t1_o_2 on t1(a) where o is not null;
drop index i_t1_o_2 on t1;
--test create index failed
create index i_t1_o_3 on t1(a) where o like '00:00%';
drop index i_t1_o_3 on t1;
--test create index failed
create index i_t1_o_4 on t1(a) where o in ('00:00:00', '00:00:01');
drop index i_t1_o_4 on t1;
--test create index failed
create index i_t1_o_5 on t1(a) where o = any {'00:00:00', '00:00:01'};
drop index i_t1_o_5 on t1;
--test create index failed
create index i_t1_o_6 on t1(a) where o = all {'00:00:00'};
drop index i_t1_o_6 on t1;
--test create index failed
create index i_t1_o_7 on t1(a) where o = some {'00:00:00', '00:00:01'};
drop index i_t1_o_7 on t1;


--test create index successfully
create index i_t1_p_1 on t1(a) where p > '2010-10-31 01:15:45';
drop index i_t1_p_1 on t1;
--test create index successfully
create index i_t1_p_2 on t1(a) where p is not null;
drop index i_t1_p_2 on t1;
--test create index failed
create index i_t1_p_3 on t1(a) where p like '2010-10-31 %';
drop index i_t1_p_3 on t1;
--test create index failed
create index i_t1_p_4 on t1(a) where p in ('2010-10-31 01:15:45', '2010-10-30 01:15:45');
drop index i_t1_p_4 on t1;
--test create index failed
create index i_t1_p_5 on t1(a) where p = any {'2010-10-31 01:15:45', '2010-10-30 01:15:45'};
drop index i_t1_p_5 on t1;
--test create index failed
create index i_t1_p_6 on t1(a) where p = all {'2010-10-31 01:15:45'};
drop index i_t1_p_6 on t1;
--test create index failed
create index i_t1_p_7 on t1(a) where p = some {'2010-10-31 01:15:45', '2010-10-30 01:15:45'};
drop index i_t1_p_7 on t1;

--test create index successfully
create index i_t1_q_1 on t1(a) where q > '2010-10-31 01:15:45';
drop index i_t1_q_1 on t1;
--test create index successfully
create index i_t1_q_2 on t1(a) where q is not null;
drop index i_t1_q_2 on t1;
--test create index failed
create index i_t1_q_3 on t1(a) where q like '2010-10-31 %';
drop index i_t1_q_3 on t1;
--test create index failed
create index i_t1_q_4 on t1(a) where q in ('2010-10-31 01:15:45', '2010-10-30 01:15:45');
drop index i_t1_q_4 on t1;
--test create index failed
create index i_t1_q_5 on t1(a) where q = any {'2010-10-31 01:15:45', '2010-10-30 01:15:45'};
drop index i_t1_q_5 on t1;
--test create index failed
create index i_t1_q_6 on t1(a) where q = all {'2010-10-31 01:15:45'};
drop index i_t1_q_6 on t1;
--test create index failed
create index i_t1_q_7 on t1(a) where q = some {'2010-10-31 01:15:45', '2010-10-30 01:15:45'};
drop index i_t1_q_7 on t1;

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
