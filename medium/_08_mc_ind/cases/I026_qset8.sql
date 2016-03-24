--+ holdcas on;
SELECT * FROM x_base_c1
        WHERE attr3_smallint_idx     > 32100
          AND attr3_smallint_noidx   > 32100 order by 1;
SELECT * FROM x_virtual_c2
        WHERE attr6_longstr_idx     < 'AZDBYUFCGLGH'
          AND attr6_longstr_noidx   < 'AZDBYUFCGLGH' order by 1;
SELECT * FROM x_base_c0
        WHERE attr11_int_2vals_idx   = 3
          AND attr11_int_2vals_noidx = 3 order by 1;
