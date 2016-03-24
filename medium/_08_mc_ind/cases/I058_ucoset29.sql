autocommit off;
UPDATE x_virtual_c2 SET 
              attr3_smallint_idx = 1212,                       
              attr4_float_idx    = 1212.12,                    
              attr5_double_idx   = 1212.12,                    
              attr6_longstr_idx  = '1212',                   
              attr7_time_idx     = '12:12:12 am',            
              attr8_date_idx     = '12/12/1972',             
              attr9_utime_idx    = '12:12:12 am 12/12/1972', 
              attr10_money_idx   = $1212.12
       WHERE attr4_float_idx IS NULL;
COMMIT WORK;
