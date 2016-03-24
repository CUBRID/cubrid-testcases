--+ holdcas on;
SELECT COUNT(*) FROM x_base_c0 a, x_virtual_c1 b
       WHERE (a.attr1_int_unique_noidx = b.attr1_int_unique_noidx)
         AND (b.attr2_str_unique_idx = 'B');
SELECT DISTINCT a.attr10_money_noidx, a.attr11_int_2vals_idx
       FROM x_base_c2 a, x_virtual_c0 b
       WHERE (a.attr1_int_unique_idx = b.attr1_int_unique_idx)
         AND (b.attr2_str_unique_noidx <> 'B') order by 1;
