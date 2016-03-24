autocommit off;
call login('dba','') on class db_user;
CREATE VCLASS co_2_3_v;
call change_owner('co_2_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_2_1_v;
call change_owner('co_2_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_5_1_v;
call change_owner('co_5_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_4_3_v;
call change_owner('co_4_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_3_3_v;
call change_owner('co_3_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_4_5_v;
call change_owner('co_4_5_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_1_1_v;
call change_owner('co_1_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_3_4_v;
call change_owner('co_3_4_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_0_v;
call change_owner('sd_0_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_3_1_v;
call change_owner('co_3_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_4_4_v;
call change_owner('co_4_4_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_1_4_v;
call change_owner('sd_1_4_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_1_5_v;
call change_owner('sd_1_5_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_2_3_v;
call change_owner('sd_2_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_3_3_v;
call change_owner('sd_3_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_4_2_v;
call change_owner('sd_4_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_5_2_v;
call change_owner('sd_5_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_6_1_v;
call change_owner('sd_6_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_7_1_v;
call change_owner('sd_7_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_8_1_v;
call change_owner('sd_8_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_9_1_v;
call change_owner('sd_9_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_10_1_v;
call change_owner('sd_10_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_11_1_v;
call change_owner('sd_11_1_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_2_4_v;
call change_owner('sd_2_4_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_3_4_v;
call change_owner('sd_3_4_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_4_3_v;
call change_owner('sd_4_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_5_3_v;
call change_owner('sd_5_3_v', 'DBA') on class db_authorizations;
CREATE VCLASS sd_6_2_v;
call change_owner('sd_6_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_0_v;
call change_owner('co_0_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_1_2_v;
call change_owner('co_1_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_2_2_v;
call change_owner('co_2_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_3_2_v;
call change_owner('co_3_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_4_2_v;
call change_owner('co_4_2_v', 'DBA') on class db_authorizations;
CREATE VCLASS co_4_6_v;
call change_owner('co_4_6_v', 'DBA') on class db_authorizations;
ALTER VCLASS co_2_3_v ADD ATTRIBUTE
       co_2_3_dub double;
ALTER VCLASS co_2_1_v ADD ATTRIBUTE
       co_2_1_dub double;
ALTER VCLASS co_5_1_v ADD ATTRIBUTE
       co_5_1_int integer;
ALTER VCLASS co_4_3_v ADD ATTRIBUTE
       co_4_3_str character varying(1073741823),
       co_4_3_ref1 co_5_1_v;
ALTER VCLASS co_3_3_v ADD ATTRIBUTE
       co_3_3_set set(integer),
       co_3_3_int integer;
ALTER VCLASS co_4_5_v ADD ATTRIBUTE
       co_4_5_tme time;
ALTER VCLASS co_1_1_v ADD METHOD
       co_1_1_met(integer, float, integer, double, date, time, monetary)character varying(1073741823) FUNCTION impl_sd_6_1_met;
ALTER VCLASS co_3_4_v ADD ATTRIBUTE
       co_3_4_dub double;
ALTER VCLASS sd_0_v ADD ATTRIBUTE
       sd_0_str character varying(1073741823) DEFAULT 'Its',
       sd_0_shared_flt float SHARED 100;
ALTER VCLASS sd_0_v ADD CLASS ATTRIBUTE 
	sd_0_class_int integer DEFAULT 0;
ALTER VCLASS sd_0_v ADD METHOD
       sd_0_met(character varying(1073741823))character varying(1073741823) FUNCTION impl_sd_0_met;
ALTER VCLASS co_3_1_v ADD ATTRIBUTE
       co_3_1_mlt multiset(integer,float,monetary),
       co_3_1_dub double,
       co_3_1_ref1 co_3_1_v;
ALTER VCLASS co_4_4_v ADD ATTRIBUTE
       co_4_4_ref1 set(co_5_1);
ALTER VCLASS co_4_4_v ADD METHOD
       co_4_4_met(integer)integer FUNCTION impl_co_4_4_met;
ALTER VCLASS sd_1_4_v ADD ATTRIBUTE
       sd_1_4_int integer DEFAULT 2147483647,
       sd_1_4_utm timestamp;
ALTER VCLASS sd_1_5_v ADD ATTRIBUTE
       sd_1_5_int integer DEFAULT 2147483647;
ALTER VCLASS sd_2_3_v ADD ATTRIBUTE
       sd_2_3_int integer DEFAULT -2147483647,
       sd_2_3_dub double DEFAULT 1.797693e308;
ALTER VCLASS sd_3_3_v ADD ATTRIBUTE
       sd_3_3_set set(integer);
ALTER VCLASS sd_4_2_v ADD ATTRIBUTE
       sd_4_2_str character varying(1073741823);
ALTER VCLASS sd_5_2_v ADD ATTRIBUTE
       sd_5_2_flt float DEFAULT 6969,
       sd_5_2_tme time,
       sd_5_2_chr character(32);
ALTER VCLASS sd_6_1_v ADD ATTRIBUTE
       sd_6_1_dte date DEFAULT date '10/22/0057';
ALTER VCLASS sd_6_1_v ADD METHOD
       sd_6_1_met(timestamp, date)timestamp FUNCTION impl_sd_6_1_met;
ALTER VCLASS sd_7_1_v ADD ATTRIBUTE
       sd_7_1_mon monetary,
       sd_7_1_mlt multiset(integer,character varying(1073741823));
ALTER VCLASS sd_8_1_v ADD ATTRIBUTE
       sd_8_1_ref1 object;
ALTER VCLASS sd_9_1_v ADD ATTRIBUTE
       sd_9_1_tme time;
ALTER VCLASS sd_10_1_v ADD ATTRIBUTE
       sd_10_1_seq set(integer);
ALTER VCLASS sd_10_1_v ADD METHOD
       sd_10_1_met(integer, set(integer))integer FUNCTION impl_sd_10_1_met;
ALTER VCLASS sd_11_1_v ADD ATTRIBUTE
       sd_11_1_str character varying(1073741823);
ALTER VCLASS sd_2_4_v ADD ATTRIBUTE
       sd_2_4_tme time,
       sd_2_4_dub double DEFAULT 4.9406564584124654e-308;
ALTER VCLASS sd_3_4_v ADD ATTRIBUTE
       sd_3_4_set set(integer);
ALTER VCLASS sd_4_3_v ADD ATTRIBUTE
       sd_4_3_str character varying(1073741823);
ALTER VCLASS sd_5_3_v ADD ATTRIBUTE
       sd_5_3_flt float DEFAULT 1.4012984643248171e-45,
       sd_5_3_tme time,
       sd_5_3_chr character(16);
ALTER VCLASS sd_6_2_v ADD ATTRIBUTE
       sd_6_2_dte date;
ALTER VCLASS co_0_v ADD ATTRIBUTE
       co_0_int integer,
       co_0_flt float,
       co_0_str character varying(1073741823),
       co_0_ref1 co_1_1,
       co_0_ref2 co_1_2;
ALTER VCLASS co_1_2_v ADD ATTRIBUTE
       co_1_2_ref1 set(co_2_1),
       co_1_2_ref2 co_2_1,
       co_1_2_ref3 set(co_2_2),
       co_1_2_ref4 co_3_4_v,
       co_1_2_ref5 co_2_3_v,
       co_1_2_ref6 co_2_3_v,
       co_1_2_ref7 co_2_3_v;
ALTER VCLASS co_1_2_v ADD METHOD
       co_1_2_met(co_1_1_v)integer FUNCTION impl_co_1_2_met;
ALTER VCLASS co_2_2_v ADD ATTRIBUTE
       co_2_2_flt float,
       co_2_2_shared_dub double SHARED 100,
       co_2_2_ref1 co_3_1_v,
       co_2_2_ref2 co_3_2_v,
       co_2_2_ref3 co_3_3_v,
       co_2_2_ref4 co_3_4_v;
ALTER VCLASS co_2_2_v ADD CLASS ATTRIBUTE 
	co_2_2_class_str character varying(1073741823) DEFAULT 'Cassidy';
ALTER VCLASS co_3_2_v ADD ATTRIBUTE
       co_3_2_fbo integer,
       co_3_2_int integer,
       co_3_2_ref1 co_4_2,
       co_3_2_ref2 co_4_3,
       co_3_2_ref3 co_4_4,
       co_3_2_ref4 co_4_5,
       co_3_2_ref5 co_4_6;
ALTER VCLASS co_4_2_v ADD ATTRIBUTE
       co_4_2_str character varying(1073741823),
       co_4_2_ref1 co_2_2_v;
ALTER VCLASS co_4_6_v ADD ATTRIBUTE
       co_4_6_set set(integer),
       co_4_6_ref1 co_1_2_v;
ALTER VCLASS sd_1_4_v ADD SUPERCLASS sd_0_v;
ALTER VCLASS sd_1_5_v ADD SUPERCLASS sd_0_v;
ALTER VCLASS sd_2_3_v ADD SUPERCLASS sd_1_4_v;
ALTER VCLASS sd_3_3_v ADD SUPERCLASS sd_2_3_v;
ALTER VCLASS sd_4_2_v ADD SUPERCLASS sd_3_3_v;
ALTER VCLASS sd_5_2_v ADD SUPERCLASS sd_4_2_v;
ALTER VCLASS sd_6_1_v ADD SUPERCLASS sd_5_2_v;
ALTER VCLASS sd_7_1_v ADD SUPERCLASS sd_6_1_v;
ALTER VCLASS sd_8_1_v ADD SUPERCLASS sd_7_1_v;
ALTER VCLASS sd_9_1_v ADD SUPERCLASS sd_8_1_v;
ALTER VCLASS sd_10_1_v ADD SUPERCLASS sd_9_1_v;
ALTER VCLASS sd_11_1_v ADD SUPERCLASS sd_10_1_v;
ALTER VCLASS sd_2_4_v ADD SUPERCLASS sd_1_5_v, sd_11_1_v;
ALTER VCLASS sd_3_4_v ADD SUPERCLASS sd_2_4_v;
ALTER VCLASS sd_4_3_v ADD SUPERCLASS sd_3_4_v;
ALTER VCLASS sd_5_3_v ADD SUPERCLASS sd_4_3_v;
ALTER VCLASS sd_6_2_v ADD SUPERCLASS sd_5_3_v;
ALTER VCLASS co_2_3_v ADD QUERY select NA from co_2_3 co_2_3 ; 
ALTER VCLASS co_2_1_v ADD QUERY select NA from co_2_1 co_2_1 ; 
ALTER VCLASS co_5_1_v ADD QUERY select NA from co_5_1 co_5_1 ; 
ALTER VCLASS co_4_3_v ADD QUERY select NA,NA from co_4_3 co_4_3 ; 
ALTER VCLASS co_3_3_v ADD QUERY select NA,NA from co_3_3 co_3_3 ; 
ALTER VCLASS co_4_5_v ADD QUERY select NA from co_4_5 co_4_5 ; 
ALTER VCLASS co_3_4_v ADD QUERY select NA from co_3_4 co_3_4 ; 
ALTER VCLASS sd_0_v ADD QUERY select NA,NA from sd_0 sd_0 ; 
ALTER VCLASS co_3_1_v ADD QUERY select NA,NA,NA from co_3_1 co_3_1 ; 
ALTER VCLASS co_4_4_v ADD QUERY select NA from co_4_4 co_4_4 ; 
ALTER VCLASS sd_1_4_v ADD QUERY select NA,NA,NA,NA from sd_1_4 sd_1_4 ; 
ALTER VCLASS sd_1_5_v ADD QUERY select NA,NA,NA from sd_1_5 sd_1_5 ; 
ALTER VCLASS sd_2_3_v ADD QUERY select NA,NA,NA,NA,NA,NA from sd_2_3 sd_2_3 ; 
ALTER VCLASS sd_3_3_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA from sd_3_3 sd_3_3 ; 
ALTER VCLASS sd_4_2_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA from sd_4_2 sd_4_2 ; 
ALTER VCLASS sd_5_2_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_5_2 sd_5_2 ; 
ALTER VCLASS sd_6_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_6_1 sd_6_1 ; 
ALTER VCLASS sd_7_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_7_1 sd_7_1 ; 
ALTER VCLASS sd_8_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_8_1 sd_8_1 ; 
ALTER VCLASS sd_9_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_9_1 sd_9_1 ; 
ALTER VCLASS sd_10_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_10_1 sd_10_1 ; 
ALTER VCLASS sd_11_1_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_11_1 sd_11_1 ; 
ALTER VCLASS sd_2_4_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_2_4 sd_2_4 ; 
ALTER VCLASS sd_3_4_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_3_4 sd_3_4 ; 
ALTER VCLASS sd_4_3_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_4_3 sd_4_3 ; 
ALTER VCLASS sd_5_3_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_5_3 sd_5_3 ; 
ALTER VCLASS sd_6_2_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA from sd_6_2 sd_6_2 ; 
ALTER VCLASS co_0_v ADD QUERY select NA,NA,NA,NA,NA from co_0 co_0 ; 
ALTER VCLASS co_1_2_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA from co_1_2 co_1_2 ; 
ALTER VCLASS co_2_2_v ADD QUERY select NA,NA,NA,NA,NA,NA from co_2_2 co_2_2 ; 
ALTER VCLASS co_3_2_v ADD QUERY select NA,NA,NA,NA,NA,NA,NA from co_3_2 co_3_2 ; 
ALTER VCLASS co_4_2_v ADD QUERY select NA,NA from co_4_2 co_4_2 ; 
ALTER VCLASS co_4_6_v ADD QUERY select NA,NA from co_4_6 co_4_6 ; 
ALTER VCLASS co_2_3_v CHANGE QUERY 1 select co_2_3.co_2_3_dub from co_2_3 co_2_3 ; 
ALTER VCLASS co_2_1_v CHANGE QUERY 1 select co_2_1.co_2_1_dub from co_2_1 co_2_1 ; 
ALTER VCLASS co_5_1_v CHANGE QUERY 1 select co_5_1.co_5_1_int from co_5_1 co_5_1 ; 
ALTER VCLASS co_4_3_v CHANGE QUERY 1 select co_4_3.co_4_3_str, co_4_3.co_4_3_ref1 from co_4_3 co_4_3 ; 
ALTER VCLASS co_3_3_v CHANGE QUERY 1 select co_3_3.co_3_3_set, co_3_3.co_3_3_int from co_3_3 co_3_3 ; 
ALTER VCLASS co_4_5_v CHANGE QUERY 1 select co_4_5.co_4_5_tme from co_4_5 co_4_5 ; 
ALTER VCLASS co_3_4_v CHANGE QUERY 1 select co_3_4.co_3_4_dub from co_3_4 co_3_4 ; 
ALTER VCLASS sd_0_v CHANGE QUERY 1 select sd_0.sd_0_str, na  from sd_0 sd_0 ; 
ALTER VCLASS co_3_1_v CHANGE QUERY 1 select co_3_1.co_3_1_mlt, co_3_1.co_3_1_dub, co_3_1.co_3_1_ref1 from co_3_1 co_3_1 ; 
ALTER VCLASS co_4_4_v CHANGE QUERY 1 select co_4_4.co_4_4_ref1 from co_4_4 co_4_4 ; 
ALTER VCLASS sd_1_4_v CHANGE QUERY 1 select sd_1_4.sd_0_str, na , sd_1_4.sd_1_4_int, sd_1_4.sd_1_4_utm from sd_1_4 sd_1_4 ; 
ALTER VCLASS sd_1_5_v CHANGE QUERY 1 select sd_1_5.sd_0_str, na , sd_1_5.sd_1_5_int from sd_1_5 sd_1_5 ; 
ALTER VCLASS sd_2_3_v CHANGE QUERY 1 select sd_2_3.sd_0_str, na , sd_2_3.sd_1_4_int, sd_2_3.sd_1_4_utm, sd_2_3.sd_2_3_int, sd_2_3.sd_2_3_dub from sd_2_3 sd_2_3 ; 
ALTER VCLASS sd_3_3_v CHANGE QUERY 1 select sd_3_3.sd_0_str, na , sd_3_3.sd_1_4_int, sd_3_3.sd_1_4_utm, sd_3_3.sd_2_3_int, sd_3_3.sd_2_3_dub, sd_3_3.sd_3_3_set from sd_3_3 sd_3_3 ; 
ALTER VCLASS sd_4_2_v CHANGE QUERY 1 select sd_4_2.sd_0_str, na , sd_4_2.sd_1_4_int, sd_4_2.sd_1_4_utm, sd_4_2.sd_2_3_int, sd_4_2.sd_2_3_dub, sd_4_2.sd_3_3_set, sd_4_2.sd_4_2_str from sd_4_2 sd_4_2 ; 
ALTER VCLASS sd_5_2_v CHANGE QUERY 1 select sd_5_2.sd_0_str, na , sd_5_2.sd_1_4_int, sd_5_2.sd_1_4_utm, sd_5_2.sd_2_3_int, sd_5_2.sd_2_3_dub, sd_5_2.sd_3_3_set, sd_5_2.sd_4_2_str, sd_5_2.sd_5_2_flt, sd_5_2.sd_5_2_tme, sd_5_2.sd_5_2_chr from sd_5_2 sd_5_2 ; 
ALTER VCLASS sd_6_1_v CHANGE QUERY 1 select sd_6_1.sd_0_str, na , sd_6_1.sd_1_4_int, sd_6_1.sd_1_4_utm, sd_6_1.sd_2_3_int, sd_6_1.sd_2_3_dub, sd_6_1.sd_3_3_set, sd_6_1.sd_4_2_str, sd_6_1.sd_5_2_flt, sd_6_1.sd_5_2_tme, sd_6_1.sd_5_2_chr, sd_6_1.sd_6_1_dte from sd_6_1 sd_6_1 ; 
ALTER VCLASS sd_7_1_v CHANGE QUERY 1 select sd_7_1.sd_0_str, na , sd_7_1.sd_1_4_int, sd_7_1.sd_1_4_utm, sd_7_1.sd_2_3_int, sd_7_1.sd_2_3_dub, sd_7_1.sd_3_3_set, sd_7_1.sd_4_2_str, sd_7_1.sd_5_2_flt, sd_7_1.sd_5_2_tme, sd_7_1.sd_5_2_chr, sd_7_1.sd_6_1_dte, sd_7_1.sd_7_1_mon, sd_7_1.sd_7_1_mlt from sd_7_1 sd_7_1 ; 
ALTER VCLASS sd_8_1_v CHANGE QUERY 1 select sd_8_1.sd_0_str, na , sd_8_1.sd_1_4_int, sd_8_1.sd_1_4_utm, sd_8_1.sd_2_3_int, sd_8_1.sd_2_3_dub, sd_8_1.sd_3_3_set, sd_8_1.sd_4_2_str, sd_8_1.sd_5_2_flt, sd_8_1.sd_5_2_tme, sd_8_1.sd_5_2_chr, sd_8_1.sd_6_1_dte, sd_8_1.sd_7_1_mon, sd_8_1.sd_7_1_mlt, sd_8_1.sd_8_1_ref1 from sd_8_1 sd_8_1 ; 
ALTER VCLASS sd_9_1_v CHANGE QUERY 1 select sd_9_1.sd_0_str, na , sd_9_1.sd_1_4_int, sd_9_1.sd_1_4_utm, sd_9_1.sd_2_3_int, sd_9_1.sd_2_3_dub, sd_9_1.sd_3_3_set, sd_9_1.sd_4_2_str, sd_9_1.sd_5_2_flt, sd_9_1.sd_5_2_tme, sd_9_1.sd_5_2_chr, sd_9_1.sd_6_1_dte, sd_9_1.sd_7_1_mon, sd_9_1.sd_7_1_mlt, sd_9_1.sd_8_1_ref1, sd_9_1.sd_9_1_tme from sd_9_1 sd_9_1 ; 
ALTER VCLASS sd_10_1_v CHANGE QUERY 1 select sd_10_1.sd_0_str, na , sd_10_1.sd_1_4_int, sd_10_1.sd_1_4_utm, sd_10_1.sd_2_3_int, sd_10_1.sd_2_3_dub, sd_10_1.sd_3_3_set, sd_10_1.sd_4_2_str, sd_10_1.sd_5_2_flt, sd_10_1.sd_5_2_tme, sd_10_1.sd_5_2_chr, sd_10_1.sd_6_1_dte, sd_10_1.sd_7_1_mon, sd_10_1.sd_7_1_mlt, sd_10_1.sd_8_1_ref1, sd_10_1.sd_9_1_tme, sd_10_1.sd_10_1_seq from sd_10_1 sd_10_1 ; 
ALTER VCLASS sd_11_1_v CHANGE QUERY 1 select sd_11_1.sd_0_str, na , sd_11_1.sd_1_4_int, sd_11_1.sd_1_4_utm, sd_11_1.sd_2_3_int, sd_11_1.sd_2_3_dub, sd_11_1.sd_3_3_set, sd_11_1.sd_4_2_str, sd_11_1.sd_5_2_flt, sd_11_1.sd_5_2_tme, sd_11_1.sd_5_2_chr, sd_11_1.sd_6_1_dte, sd_11_1.sd_7_1_mon, sd_11_1.sd_7_1_mlt, sd_11_1.sd_8_1_ref1, sd_11_1.sd_9_1_tme, sd_11_1.sd_10_1_seq, sd_11_1.sd_11_1_str from sd_11_1 sd_11_1 ; 
ALTER VCLASS sd_2_4_v CHANGE QUERY 1 select sd_2_4.sd_0_str, na , sd_2_4.sd_1_5_int, sd_2_4.sd_1_4_int, sd_2_4.sd_1_4_utm, sd_2_4.sd_2_3_int, sd_2_4.sd_2_3_dub, sd_2_4.sd_3_3_set, sd_2_4.sd_4_2_str, sd_2_4.sd_5_2_flt, sd_2_4.sd_5_2_tme, sd_2_4.sd_5_2_chr, sd_2_4.sd_6_1_dte, sd_2_4.sd_7_1_mon, sd_2_4.sd_7_1_mlt, sd_2_4.sd_8_1_ref1, sd_2_4.sd_9_1_tme, sd_2_4.sd_10_1_seq, sd_2_4.sd_11_1_str, sd_2_4.sd_2_4_tme, sd_2_4.sd_2_4_dub from sd_2_4 sd_2_4 ; 
ALTER VCLASS sd_3_4_v CHANGE QUERY 1 select sd_3_4.sd_0_str, na , sd_3_4.sd_1_5_int, sd_3_4.sd_1_4_int, sd_3_4.sd_1_4_utm, sd_3_4.sd_2_3_int, sd_3_4.sd_2_3_dub, sd_3_4.sd_3_3_set, sd_3_4.sd_4_2_str, sd_3_4.sd_5_2_flt, sd_3_4.sd_5_2_tme, sd_3_4.sd_5_2_chr, sd_3_4.sd_6_1_dte, sd_3_4.sd_7_1_mon, sd_3_4.sd_7_1_mlt, sd_3_4.sd_8_1_ref1, sd_3_4.sd_9_1_tme, sd_3_4.sd_10_1_seq, sd_3_4.sd_11_1_str, sd_3_4.sd_2_4_tme, sd_3_4.sd_2_4_dub, sd_3_4.sd_3_4_set from sd_3_4 sd_3_4 ; 
ALTER VCLASS sd_4_3_v CHANGE QUERY 1 select sd_4_3.sd_0_str, na , sd_4_3.sd_1_5_int, sd_4_3.sd_1_4_int, sd_4_3.sd_1_4_utm, sd_4_3.sd_2_3_int, sd_4_3.sd_2_3_dub, sd_4_3.sd_3_3_set, sd_4_3.sd_4_2_str, sd_4_3.sd_5_2_flt, sd_4_3.sd_5_2_tme, sd_4_3.sd_5_2_chr, sd_4_3.sd_6_1_dte, sd_4_3.sd_7_1_mon, sd_4_3.sd_7_1_mlt, sd_4_3.sd_8_1_ref1, sd_4_3.sd_9_1_tme, sd_4_3.sd_10_1_seq, sd_4_3.sd_11_1_str, sd_4_3.sd_2_4_tme, sd_4_3.sd_2_4_dub, sd_4_3.sd_3_4_set, sd_4_3.sd_4_3_str from sd_4_3 sd_4_3 ; 
ALTER VCLASS sd_5_3_v CHANGE QUERY 1 select sd_5_3.sd_0_str, na , sd_5_3.sd_1_5_int, sd_5_3.sd_1_4_int, sd_5_3.sd_1_4_utm, sd_5_3.sd_2_3_int, sd_5_3.sd_2_3_dub, sd_5_3.sd_3_3_set, sd_5_3.sd_4_2_str, sd_5_3.sd_5_2_flt, sd_5_3.sd_5_2_tme, sd_5_3.sd_5_2_chr, sd_5_3.sd_6_1_dte, sd_5_3.sd_7_1_mon, sd_5_3.sd_7_1_mlt, sd_5_3.sd_8_1_ref1, sd_5_3.sd_9_1_tme, sd_5_3.sd_10_1_seq, sd_5_3.sd_11_1_str, sd_5_3.sd_2_4_tme, sd_5_3.sd_2_4_dub, sd_5_3.sd_3_4_set, sd_5_3.sd_4_3_str, sd_5_3.sd_5_3_flt, sd_5_3.sd_5_3_tme, sd_5_3.sd_5_3_chr from sd_5_3 sd_5_3 ; 
ALTER VCLASS sd_6_2_v CHANGE QUERY 1 select sd_6_2.sd_0_str, na , sd_6_2.sd_1_5_int, sd_6_2.sd_1_4_int, sd_6_2.sd_1_4_utm, sd_6_2.sd_2_3_int, sd_6_2.sd_2_3_dub, sd_6_2.sd_3_3_set, sd_6_2.sd_4_2_str, sd_6_2.sd_5_2_flt, sd_6_2.sd_5_2_tme, sd_6_2.sd_5_2_chr, sd_6_2.sd_6_1_dte, sd_6_2.sd_7_1_mon, sd_6_2.sd_7_1_mlt, sd_6_2.sd_8_1_ref1, sd_6_2.sd_9_1_tme, sd_6_2.sd_10_1_seq, sd_6_2.sd_11_1_str, sd_6_2.sd_2_4_tme, sd_6_2.sd_2_4_dub, sd_6_2.sd_3_4_set, sd_6_2.sd_4_3_str, sd_6_2.sd_5_3_flt, sd_6_2.sd_5_3_tme, sd_6_2.sd_5_3_chr, sd_6_2.sd_6_2_dte from sd_6_2 sd_6_2 ; 
ALTER VCLASS co_0_v CHANGE QUERY 1 select co_0.co_0_int, co_0.co_0_flt, co_0.co_0_str, co_0.co_0_ref1, co_0.co_0_ref2 from co_0 co_0 ; 
ALTER VCLASS co_1_2_v CHANGE QUERY 1 select co_1_2.co_1_2_ref1, co_1_2.co_1_2_ref2, co_1_2.co_1_2_ref3, co_1_2.co_1_2_ref4, co_1_2.co_1_2_ref5, co_1_2.co_1_2_ref6, co_1_2.co_1_2_ref7 from co_1_2 co_1_2 ; 
ALTER VCLASS co_2_2_v CHANGE QUERY 1 select co_2_2.co_2_2_flt, na , co_2_2.co_2_2_ref1, co_2_2.co_2_2_ref2, co_2_2.co_2_2_ref3, co_2_2.co_2_2_ref4 from co_2_2 co_2_2 ; 
ALTER VCLASS co_3_2_v CHANGE QUERY 1 select co_3_2.co_3_2_fbo, co_3_2.co_3_2_int, co_3_2.co_3_2_ref1, co_3_2.co_3_2_ref2, co_3_2.co_3_2_ref3, co_3_2.co_3_2_ref4, co_3_2.co_3_2_ref5 from co_3_2 co_3_2 ; 
ALTER VCLASS co_4_2_v CHANGE QUERY 1 select co_4_2.co_4_2_str, co_4_2.co_4_2_ref1 from co_4_2 co_4_2 ; 
ALTER VCLASS co_4_6_v CHANGE QUERY 1 select co_4_6.co_4_6_set, co_4_6.co_4_6_ref1 from co_4_6 co_4_6 ; 
select sd_5_3_tme
 from sd_6_2_v
 where sd_5_3_flt in
  ( select  y.co_2_2_flt
    from co_0_v x, table( x.co_0_ref2.co_1_2_ref3) as t(y)
    where x.co_0_ref2.co_1_2_ref2.co_2_1_dub in
     ( select co_1_2_ref2.co_2_1_dub
       from co_1_2_v
       where co_1_2_ref5.co_2_3_dub <> x.co_0_ref2.co_1_2_ref4.co_3_4_dub
     )
 ) ;
 rollback;
 call login('dba','') on class db_user;
 
