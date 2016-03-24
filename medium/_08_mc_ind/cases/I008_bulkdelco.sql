autocommit off;
CREATE CLASS x_base_c1_save_del;
ALTER CLASS x_base_c1_save_del
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
                 attr16_objpath           x_base_c2;
INSERT INTO x_base_c1_save_del 
  SELECT * FROM x_base_c1
        WHERE (attr14_int_10vals_idx >= 0
               AND attr14_int_10vals_idx < 2)
           OR attr14_int_10vals_idx = 7
           OR attr14_int_10vals_idx = 5;
DELETE FROM x_base_c1
       WHERE (attr14_int_10vals_idx >= 0
              AND attr14_int_10vals_idx < 2)
          OR attr14_int_10vals_idx = 7
          OR attr14_int_10vals_idx = 5;
COMMIT WORK;
SELECT COUNT(*) FROM x_virtual_c1;
SELECT attr1_int_unique_idx FROM x_base_c1
        WHERE attr1_int_unique_idx   >=  5
          AND attr1_int_unique_idx   <= 15;
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr2_str_unique_idx BETWEEN 'ABC' AND 'IQB';
SELECT attr3_smallint_idx FROM x_base_c1
        WHERE attr3_smallint_idx > 7
          AND attr3_smallint_idx < 21;
SELECT attr4_float_idx FROM x_virtual_c1
        WHERE attr4_float_idx > 12.10
          AND attr4_float_idx < 15.10;
SELECT COUNT(*) FROM x_base_c1
        WHERE attr6_longstr_idx  > 'ACSUQBLNAVXVXAYGNTMM'
          AND attr6_longstr_idx < 'ZOGYOZPUMCEPSAKMEIRDJZJQ';
SELECT attr7_time_idx FROM x_virtual_c1
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15';
SELECT attr8_date_idx FROM x_base_c1
       WHERE attr8_date_idx         < '11/11/1972';
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1982' 
          AND '12:30:15 12/11/1990';
SELECT attr10_money_idx FROM x_base_c1
        WHERE attr10_money_idx > $36.10
          AND attr10_money_idx < $715.10;
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr11_int_2vals_idx   <> 0;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM x_base_c1
        WHERE attr15_int_50vals_idx   BETWEEN 20 AND 24;
INSERT INTO x_base_c1 SELECT * FROM x_base_c1_save_del;
DROP x_base_c1_save_del;
COMMIT WORK;
SELECT COUNT(*) FROM x_virtual_c1;
SELECT attr1_int_unique_idx FROM x_base_c1
        WHERE attr1_int_unique_idx   >=  5
          AND attr1_int_unique_idx   <= 15;
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr2_str_unique_idx BETWEEN 'ABC' AND 'IQB';
SELECT attr3_smallint_idx FROM x_base_c1
        WHERE attr3_smallint_idx > 7
          AND attr3_smallint_idx < 21;
SELECT attr4_float_idx FROM x_virtual_c1
        WHERE attr4_float_idx > 12.10
          AND attr4_float_idx < 15.10;
SELECT COUNT(*) FROM x_base_c1
        WHERE attr6_longstr_idx  > 'ACSUQBLNAVXVXAYGNTMM'
          AND attr6_longstr_idx < 'ZOGYOZPUMCEPSAKMEIRDJZJQ';
SELECT attr7_time_idx FROM x_virtual_c1
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15';
SELECT attr8_date_idx FROM x_base_c1
       WHERE attr8_date_idx         < '11/11/1972';
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1982' 
          AND '12:30:15 12/11/1990';
SELECT attr10_money_idx FROM x_base_c1
        WHERE attr10_money_idx > $36.10
          AND attr10_money_idx < $715.10;
SELECT COUNT(*) FROM x_virtual_c1
        WHERE attr11_int_2vals_idx   <> 0;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM x_base_c1
        WHERE attr15_int_50vals_idx   BETWEEN 20 AND 24;
COMMIT WORK;
