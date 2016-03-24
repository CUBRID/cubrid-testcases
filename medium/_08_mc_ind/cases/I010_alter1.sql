autocommit off;
CREATE CLASS x_base_c0_save;
ALTER CLASS x_base_c0_save
      ADD ATTRIBUTE
                 attr1_int_unique_idx     integer,   
                 attr1_int_unique_noidx   integer,   
                 attr2_str_unique_idx     char(10),   
                 attr2_str_unique_noidx   char(10),   
                 attr3_smallint_idx       smallint,  
                 attr3_smallint_noidx     smallint,  
                 attr4_float_idx          float,     
                 attr4_float_noidx        float,     
                 attr5_double_idx         double,    
                 attr5_double_noidx       double,    
                 attr6_longstr_idx        string,    
                 attr6_longstr_noidx      string,    
                 attr7_time_idx           time,      
                 attr7_time_noidx         time,      
                 attr8_date_idx           date,      
                 attr8_date_noidx         date,      
                 attr9_utime_idx          utime,     
                 attr9_utime_noidx        utime,     
                 attr10_money_idx         monetary,  
                 attr10_money_noidx       monetary,  
                 attr11_int_2vals_idx     integer,   
                 attr11_int_2vals_noidx   integer,   
                 attr12_int_4vals_idx     integer,   
                 attr12_int_4vals_noidx   integer,   
                 attr13_int_5vals_idx     integer,   
                 attr13_int_5vals_noidx   integer,   
                 attr14_int_10vals_idx    integer,   
                 attr14_int_10vals_noidx  integer,   
                 attr15_int_50vals_idx    integer,   
                 attr15_int_50vals_noidx  integer,   
                 attr16_dep_tag_noidx     char(30),  
                 attr16_objpath           x_base_c1;
INSERT INTO x_base_c0_save 
  SELECT * FROM x_base_c0;
ALTER CLASS x_base_c0
      ADD ATTRIBUTE tmp_attr1 integer,
                    tmp_attr2 integer;
ALTER CLASS x_base_c0
      DROP ATTRIBUTE attr3_smallint_noidx, attr4_float_noidx;
SELECT * FROM x_base_c0 WHERE attr1_int_unique_idx < 5 order by attr1_int_unique_idx;
DROP x_base_c0_save;
CREATE CLASS x_base_c0;
ALTER CLASS x_base_c0
      ADD ATTRIBUTE
                 attr1_int_unique_idx     integer,   
                 attr1_int_unique_noidx   integer,   
                 attr2_str_unique_idx     char(10),   
                 attr2_str_unique_noidx   char(10),   
                 attr3_smallint_idx       smallint,  
                 attr3_smallint_noidx     smallint,  
                 attr4_float_idx          float,     
                 attr4_float_noidx        float,     
                 attr5_double_idx         double,    
                 attr5_double_noidx       double,    
                 attr6_longstr_idx        string,    
                 attr6_longstr_noidx      string,    
                 attr7_time_idx           time,      
                 attr7_time_noidx         time,      
                 attr8_date_idx           date,      
                 attr8_date_noidx         date,      
                 attr9_utime_idx          utime,     
                 attr9_utime_noidx        utime,     
                 attr10_money_idx         monetary,  
                 attr10_money_noidx       monetary,  
                 attr11_int_2vals_idx     integer,   
                 attr11_int_2vals_noidx   integer,   
                 attr12_int_4vals_idx     integer,   
                 attr12_int_4vals_noidx   integer,   
                 attr13_int_5vals_idx     integer,   
                 attr13_int_5vals_noidx   integer,   
                 attr14_int_10vals_idx    integer,   
                 attr14_int_10vals_noidx  integer,   
                 attr15_int_50vals_idx    integer,   
                 attr15_int_50vals_noidx  integer,   
                 attr16_dep_tag_noidx     char(30),  
                 attr16_objpath           x_base_c1;
CREATE VCLASS x_virtual_c0 (
                 attr1_int_unique_idx     integer,   
                 attr1_int_unique_noidx   integer,   
                 attr2_str_unique_idx     char(10),   
                 attr2_str_unique_noidx   char(10),   
                 attr3_smallint_idx       smallint,  
                 attr3_smallint_noidx     smallint,  
                 attr4_float_idx          float,     
                 attr4_float_noidx        float,     
                 attr5_double_idx         double,    
                 attr5_double_noidx       double,    
                 attr6_longstr_idx        string,    
                 attr6_longstr_noidx      string,    
                 attr7_time_idx           time,      
                 attr7_time_noidx         time,      
                 attr8_date_idx           date,      
                 attr8_date_noidx         date,      
                 attr9_utime_idx          utime,     
                 attr9_utime_noidx        utime,     
                 attr10_money_idx         monetary,  
                 attr10_money_noidx       monetary,  
                 attr11_int_2vals_idx     integer,   
                 attr11_int_2vals_noidx   integer,   
                 attr12_int_4vals_idx     integer,   
                 attr12_int_4vals_noidx   integer,   
                 attr13_int_5vals_idx     integer,   
                 attr13_int_5vals_noidx   integer,   
                 attr14_int_10vals_idx    integer,   
                 attr14_int_10vals_noidx  integer,   
                 attr15_int_50vals_idx    integer,   
                 attr15_int_50vals_noidx  integer,   
                 attr16_dep_tag_noidx     char(30),  
                 attr16_objpath           x_base_c1)        
 AS SELECT * FROM x_base_c0;
INSERT INTO x_base_c0 SELECT * FROM x_base_c0_save;
DROP x_base_c0_save;
CREATE INDEX idx1 ON x_base_c0(attr1_int_unique_idx);
CREATE INDEX idx2 ON x_base_c0(attr2_str_unique_idx);
CREATE INDEX idx3 ON x_base_c0(attr3_smallint_idx);
CREATE INDEX idx4 ON x_base_c0(attr4_float_idx);
CREATE INDEX idx5 ON x_base_c0(attr5_double_idx);
CREATE INDEX idx6 ON x_base_c0(attr6_longstr_idx);
CREATE INDEX idx7 ON x_base_c0(attr7_time_idx);
CREATE INDEX idx8 ON x_base_c0(attr8_date_idx);
CREATE INDEX idx9 ON x_base_c0(attr9_utime_idx);
CREATE INDEX idx10 ON x_base_c0(attr10_money_idx);
CREATE INDEX idx11 ON x_base_c0(attr11_int_2vals_idx);
CREATE INDEX idx12 ON x_base_c0(attr12_int_4vals_idx);
CREATE INDEX idx13 ON x_base_c0(attr13_int_5vals_idx);
CREATE INDEX idx14 ON x_base_c0(attr14_int_10vals_idx);
CREATE INDEX idx15 ON x_base_c0(attr15_int_50vals_idx);
ROLLBACK WORK;
SELECT * FROM x_base_c0 WHERE attr1_int_unique_idx < 5 order by attr1_int_unique_idx;
