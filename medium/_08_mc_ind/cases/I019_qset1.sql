--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0
       WHERE attr1_int_unique_idx   <> 0;
SELECT COUNT(*) FROM x_virtual_c1
       WHERE attr2_str_unique_noidx <> 'ABC';
SELECT COUNT(*) FROM x_base_c2
       WHERE attr3_smallint_idx     <> 125;
SELECT COUNT(*) FROM x_virtual_c0
       WHERE attr4_float_noidx      <> 125.67;
SELECT COUNT(*) FROM x_base_c1
       WHERE attr5_double_idx       <> 125.67;
SELECT COUNT(*) FROM x_virtual_c2
       WHERE attr6_longstr_noidx    <> 'SJEOAKNSHAYLRKORFKCJ';
SELECT COUNT(*) FROM x_base_c0
       WHERE attr7_time_idx         <> '09:30:15 am';
SELECT COUNT(*) FROM x_virtual_c1
       WHERE attr8_date_noidx       <> '11/11/1972';
SELECT COUNT(*) FROM x_base_c2
       WHERE attr9_utime_idx        <> '09:30:15 11/11/1972';
SELECT COUNT(*) FROM x_virtual_c0
       WHERE attr10_money_noidx     <> $120.00;
