--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0;
SELECT attr1_int_unique_idx FROM x_virtual_c1
        WHERE attr1_int_unique_idx   >=  5
          AND attr1_int_unique_idx   <= 15 order by 1;
SELECT COUNT(*) FROM x_base_c2
        WHERE attr2_str_unique_idx BETWEEN 'ABC' AND 'IQB';
SELECT attr3_smallint_idx FROM x_virtual_c0
        WHERE attr3_smallint_idx > 7
          AND attr3_smallint_idx < 21 order by 1;
SELECT attr4_float_idx FROM x_base_c1
        WHERE attr4_float_idx > 12.10
          AND attr4_float_idx < 15.10 order by 1;
SELECT COUNT(*) FROM x_virtual_c2
        WHERE attr6_longstr_idx  > 'ACSUQBLNAVXVXAYGNTMM'
          AND attr6_longstr_idx < 'ZOGYOZPUMCEPSAKMEIRDJZJQ';
SELECT attr7_time_idx FROM x_base_c0
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15' order by 1;
SELECT attr8_date_idx FROM x_virtual_c1
       WHERE attr8_date_idx         < '11/11/1972' order by 1;
SELECT COUNT(*) FROM x_base_c2
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1982' 
          AND '12:30:15 12/11/1990';
SELECT attr10_money_idx FROM x_virtual_c0
        WHERE attr10_money_idx > $36.10
          AND attr10_money_idx < $715.10 order by 1;
SELECT COUNT(*) FROM x_base_c1
        WHERE attr11_int_2vals_idx   <> 0;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM x_virtual_c2
        WHERE attr15_int_50vals_idx   BETWEEN 20 AND 24 order by 1;
