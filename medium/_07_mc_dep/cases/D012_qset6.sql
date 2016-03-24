--+ holdcas on;
SELECT * FROM virtual_c2
        WHERE attr1_int_unique_idx = 0
          AND attr2_str_unique_idx = 'A' order by 1;
SELECT * FROM base_c0
        WHERE attr1_int_unique_idx < 123
          AND attr4_float_idx      < 123.2 order by 1;
