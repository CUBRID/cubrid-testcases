--+ holdcas on;
SELECT attr2_str_unique_noidx, attr1_int_unique_idx
       FROM x_virtual_c2 a
       WHERE EXISTS
             (SELECT * FROM x_base_c0 b
                       WHERE b.attr10_money_idx = a.attr10_money_idx
                         AND b.attr8_date_idx  > '11/11/1989') order by 1;
