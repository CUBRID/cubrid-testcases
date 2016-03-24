--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0
        WHERE attr16_objpath.attr15_int_50vals_idx  = 24
          AND attr16_objpath.attr14_int_10vals_idx  > 2
          AND attr16_objpath.attr11_int_2vals_idx   < 1;
SELECT * FROM x_virtual_c1
        WHERE attr16_objpath.attr1_int_unique_idx < 123
          AND attr16_objpath.attr4_float_idx      < 123.2 order by 1;
SELECT * FROM x_base_c2
        WHERE attr16_objpath.attr6_longstr_idx     < 'AZDBYUFCGLGH'
          AND attr16_objpath.attr6_longstr_noidx   < 'AZDBYUFCGLGH' order by 1;
