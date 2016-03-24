--+ holdcas on;
SELECT attr2_str_unique_noidx, attr1_int_unique_idx
       FROM x_virtual_c2
         WHERE  attr16_objpath.attr10_money_idx = attr10_money_idx
            AND attr16_objpath.attr8_date_idx  > '11/11/1989' order by 1;
