--+ holdcas on;
SELECT AVG(attr12_int_4vals_idx)   FROM x_base_c0 order by 1;
SELECT AVG(attr1_int_unique_noidx) FROM x_virtual_c1 order by 1;
SELECT MAX(attr2_str_unique_noidx) FROM x_base_c2 order by 1;
SELECT MAX(attr15_int_50vals_idx) - MIN(attr15_int_50vals_idx)
       FROM x_virtual_c0
       WHERE attr14_int_10vals_idx = 3 order by 1;
SELECT SUM(attr4_float_idx) FROM x_base_c1
       WHERE (attr1_int_unique_idx BETWEEN 10000 AND 10200
              OR attr1_int_unique_idx BETWEEN 10400 AND 10600
              OR attr1_int_unique_idx BETWEEN 10800 AND 11200
              OR attr1_int_unique_idx BETWEEN 11400 AND 11600
              OR attr1_int_unique_idx BETWEEN 11800 AND 12000)
         AND attr15_int_50vals_idx = 3 order by 1;
SELECT AVG(attr1_int_unique_idx), MIN(attr1_int_unique_idx),
       MAX(attr1_int_unique_idx), MIN(attr8_date_idx), 
       MAX(attr8_date_idx), COUNT(DISTINCT attr15_int_50vals_idx),
       COUNT(attr15_int_50vals_idx), COUNT(attr2_str_unique_idx)
  FROM x_base_c0 order by 1;
