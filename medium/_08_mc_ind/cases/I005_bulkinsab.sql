autocommit off;
SELECT MAX(attr1_int_unique_idx) + 1 TO :maxvalue FROM x_base_c1;
INSERT INTO x_base_c1 
    SELECT  attr1_int_unique_idx   + :maxvalue, 
            attr1_int_unique_noidx + :maxvalue, 
            cast(attr1_int_unique_idx + :maxvalue as string),   
            cast(attr1_int_unique_idx + :maxvalue as string),   
            attr3_smallint_idx,       
            attr3_smallint_noidx,     
            attr4_float_idx,          
            attr4_float_noidx,        
            attr5_double_idx,         
            attr5_double_noidx,       
            attr6_longstr_idx,        
            attr6_longstr_noidx,      
            attr7_time_idx,           
            attr7_time_noidx,         
            attr8_date_idx,           
            attr8_date_noidx,         
            attr9_utime_idx,          
            attr9_utime_noidx,        
            attr10_money_idx,         
            attr10_money_noidx,       
            attr11_int_2vals_idx,     
            attr11_int_2vals_noidx,   
            attr12_int_4vals_idx,     
            attr12_int_4vals_noidx,   
            attr13_int_5vals_idx,     
            attr13_int_5vals_noidx,   
            attr14_int_10vals_idx,    
            attr14_int_10vals_noidx,  
            attr15_int_50vals_idx,    
            attr15_int_50vals_noidx,  
            attr16_dep_tag_noidx,     
            attr16_objpath            
       FROM x_base_c1
        WHERE attr14_int_10vals_idx > 2
          AND attr14_int_10vals_idx < 6;
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
ROLLBACK WORK;
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
ROLLBACK WORK;
