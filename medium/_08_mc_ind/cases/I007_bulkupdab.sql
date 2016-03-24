autocommit off;
UPDATE x_virtual_c0
   SET attr1_int_unique_idx   = - attr1_int_unique_idx,
       attr3_smallint_idx     = - attr3_smallint_idx,
       attr4_float_idx        = - attr4_float_idx,
       attr5_double_idx       = attr5_double_idx,
       attr6_longstr_idx      = 'UPDATE' + attr6_longstr_idx,
       attr7_time_idx         = attr7_time_idx + 12,
       attr8_date_idx         = attr8_date_idx + 12,
       attr9_utime_idx        = attr9_utime_idx + 12,
       attr10_money_idx       = - attr10_money_idx,
       attr11_int_2vals_idx   = - attr11_int_2vals_idx,
       attr12_int_4vals_idx   = - attr12_int_4vals_idx,
       attr13_int_5vals_idx   = - attr13_int_5vals_idx,
       attr15_int_50vals_idx  = - attr15_int_50vals_idx
   WHERE attr14_int_10vals_idx > 5
     AND attr14_int_10vals_idx < 9 ;
SELECT COUNT(*) FROM x_base_c0;
SELECT attr1_int_unique_idx FROM x_virtual_c0
        WHERE attr1_int_unique_idx   >=  5
          AND attr1_int_unique_idx   <= 15 order by 1;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr2_str_unique_idx BETWEEN 'ABC' AND 'IQB';
SELECT attr3_smallint_idx FROM x_virtual_c0
        WHERE attr3_smallint_idx > 7
          AND attr3_smallint_idx < 21 order by 1;
SELECT attr4_float_idx FROM x_base_c0
        WHERE attr4_float_idx > 12.10
          AND attr4_float_idx < 15.10 order by 1;
SELECT COUNT(*) FROM x_virtual_c0
        WHERE attr6_longstr_idx  > 'ACSUQBLNAVXVXAYGNTMM'
          AND attr6_longstr_idx < 'ZOGYOZPUMCEPSAKMEIRDJZJQ';
SELECT attr7_time_idx FROM x_base_c0
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15' order by 1;
SELECT attr8_date_idx FROM x_virtual_c0
       WHERE attr8_date_idx         < '11/11/1972' order by 1;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1982' 
          AND '12:30:15 12/11/1990';
SELECT attr10_money_idx FROM x_virtual_c0
        WHERE attr10_money_idx > $36.10
          AND attr10_money_idx < $715.10 order by 1;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr11_int_2vals_idx   <> 0;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM x_virtual_c0
        WHERE attr15_int_50vals_idx   BETWEEN 20 AND 24 order by 1;
ROLLBACK WORK;
SELECT COUNT(*) FROM x_base_c0;
SELECT attr1_int_unique_idx FROM x_virtual_c0
        WHERE attr1_int_unique_idx   >=  5
          AND attr1_int_unique_idx   <= 15;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr2_str_unique_idx BETWEEN 'ABC' AND 'IQB';
SELECT attr3_smallint_idx FROM x_virtual_c0
        WHERE attr3_smallint_idx > 7
          AND attr3_smallint_idx < 21;
SELECT attr4_float_idx FROM x_base_c0
        WHERE attr4_float_idx > 12.10
          AND attr4_float_idx < 15.10;
SELECT COUNT(*) FROM x_virtual_c0
        WHERE attr6_longstr_idx  > 'ACSUQBLNAVXVXAYGNTMM'
          AND attr6_longstr_idx < 'ZOGYOZPUMCEPSAKMEIRDJZJQ';
SELECT attr7_time_idx FROM x_base_c0
        WHERE attr7_time_idx  BETWEEN '09:30:15 am' 
          AND '12:30:15';
SELECT attr8_date_idx FROM x_virtual_c0
       WHERE attr8_date_idx         < '11/11/1972';
SELECT COUNT(*) FROM x_base_c0
        WHERE attr9_utime_idx  BETWEEN '09:30:15 11/11/1982' 
          AND '12:30:15 12/11/1990';
SELECT attr10_money_idx FROM x_virtual_c0
        WHERE attr10_money_idx > $36.10
          AND attr10_money_idx < $715.10;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr11_int_2vals_idx   <> 0;
SELECT attr1_int_unique_idx, attr15_int_50vals_idx   FROM x_virtual_c0
        WHERE attr15_int_50vals_idx   BETWEEN 20 AND 24;
ROLLBACK WORK;
