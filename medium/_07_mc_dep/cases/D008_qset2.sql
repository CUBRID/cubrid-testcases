--+ holdcas on;
SELECT COUNT(DISTINCT attr1_int_unique_noidx) FROM base_c1
       WHERE attr1_int_unique_noidx <> 0;
SELECT COUNT(DISTINCT attr2_str_unique_idx) FROM virtual_c2
       WHERE attr2_str_unique_idx   <> 'ABC';
SELECT COUNT(DISTINCT attr3_smallint_noidx) FROM base_c0
       WHERE attr3_smallint_noidx   <> 125;
SELECT COUNT(DISTINCT attr4_float_idx) FROM virtual_c1
       WHERE attr4_float_idx        <> 125.67;
SELECT COUNT(DISTINCT attr5_double_noidx) FROM base_c2
       WHERE attr5_double_noidx     <> 125.67;
SELECT COUNT(DISTINCT attr6_longstr_idx) FROM virtual_c0
       WHERE attr6_longstr_idx      <> 'SJEOAKNSHAYLRKORFKCJ';
SELECT COUNT(DISTINCT attr7_time_noidx) FROM base_c1
       WHERE attr7_time_noidx       <> '09:30:15 am';
SELECT COUNT(DISTINCT attr8_date_idx) FROM virtual_c2
       WHERE attr8_date_idx         <> '11/11/1972';
SELECT COUNT(DISTINCT attr9_utime_noidx) FROM base_c0
       WHERE attr9_utime_noidx      <> '09:30:15 11/11/1972';
SELECT COUNT(DISTINCT attr10_money_idx) FROM virtual_c1
       WHERE attr10_money_idx       <> $120.00;
