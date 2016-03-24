--+ holdcas on;
SELECT attr1_int_unique_idx FROM base_c0
        WHERE attr1_int_unique_idx   = 1 order by 1;
SELECT attr1_int_unique_noidx, attr2_str_unique_noidx FROM virtual_c1
        WHERE attr2_str_unique_noidx = 'A' order by 1,2;
SELECT attr1_int_unique_noidx, attr3_smallint_noidx FROM base_c2
        WHERE attr3_smallint_noidx > 1400
          AND attr3_smallint_idx   < 1501 order by 1,2;
SELECT attr1_int_unique_noidx, attr4_float_noidx FROM virtual_c0
        WHERE attr4_float_noidx > 1212.10
          AND attr4_float_idx   < 1312.10 order by 1,2;
SELECT attr1_int_unique_idx, attr5_double_idx FROM base_c1
        WHERE attr5_double_noidx > 1212.10
          AND attr5_double_idx   < 1312.10 order by 1,2;
SELECT attr1_int_unique_idx, attr6_longstr_idx FROM virtual_c2
        WHERE attr6_longstr_noidx  > 'EVGXOBMZSDVMAFBKACZLPX'
          AND attr6_longstr_idx    <  'FMXSKEXFOJGUGRINLPRAVJOZTUTL' order by 1,2;
SELECT attr1_int_unique_idx, attr7_time_idx FROM base_c0
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15' order by 1,2 ;
SELECT attr1_int_unique_noidx, attr8_date_noidx FROM virtual_c1
        WHERE attr8_date_noidx  BETWEEN '11/11/1989' 
          AND '12/11/1990' order by 1,2;
SELECT attr1_int_unique_idx, attr9_utime_idx FROM base_c2
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1989' 
          AND '12:30:15 12/11/1990' order by 1,2;
SELECT attr1_int_unique_idx, attr10_money_idx FROM virtual_c0
        WHERE attr10_money_idx > $112.10
          AND attr10_money_idx < $155.10 order by 1,2;
