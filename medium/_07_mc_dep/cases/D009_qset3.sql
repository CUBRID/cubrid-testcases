autocommit off ;
SELECT attr1_int_unique_idx FROM virtual_c2
       WHERE attr1_int_unique_idx > 100 AND
             attr1_int_unique_idx < 200
       ORDER BY attr1_int_unique_idx ;
SELECT attr5_double_idx FROM base_c0
       WHERE attr5_double_idx < 123456.10
       ORDER BY attr5_double_idx;
SELECT attr6_longstr_idx FROM virtual_c1
       WHERE attr6_longstr_idx > 'XTZUVRWQS123'
       ORDER BY attr6_longstr_idx;
SELECT attr8_date_noidx FROM base_c2
       WHERE attr8_date_noidx > '11/11/1998' 
       ORDER BY attr8_date_noidx ;
SELECT attr9_utime_idx FROM virtual_c0
       WHERE attr9_utime_idx > '09:30:15 11/11/1998' 
       ORDER BY attr9_utime_idx ;
SELECT DISTINCT attr11_int_2vals_idx FROM base_c1
       ORDER BY attr11_int_2vals_idx ;
SELECT DISTINCT attr4_float_idx        FROM virtual_c2
       ORDER BY attr4_float_idx;
SELECT DISTINCT attr7_time_noidx       FROM base_c0
       ORDER BY attr7_time_noidx;
