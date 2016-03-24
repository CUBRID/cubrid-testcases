--+ holdcas on;
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM base_c0
         WHERE attr1_int_unique_idx <= 5
UNION
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM virtual_c1
       WHERE attr1_int_unique_idx <= 10;
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM base_c2
       WHERE attr8_date_idx  > '11/11/1989'
DIFFERENCE
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM virtual_c0
       WHERE attr5_double_idx <> 125.67
 order by 1;
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM base_c1
       WHERE attr1_int_unique_idx <= 10
INTERSECTION
SELECT     attr1_int_unique_idx,     
           attr2_str_unique_idx,     
           attr5_double_noidx,       
           attr6_longstr_noidx,      
           attr7_time_idx,           
           attr8_date_idx,           
           attr9_utime_idx,          
           attr10_money_idx,         
           attr11_int_2vals_idx,     
           attr12_int_4vals_idx,     
           attr15_int_50vals_idx     
     FROM virtual_c2
       WHERE attr1_int_unique_noidx > 8 and attr1_int_unique_noidx < 500
 order by 1;
