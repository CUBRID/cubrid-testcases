autocommit off;
UPDATE x_base_c0
   SET attr16_objpath = 
       (SELECT t FROM x_base_c1 AS t
            WHERE t.attr1_int_unique_idx = x_base_c0.attr1_int_unique_idx);
UPDATE x_base_c1
   SET attr16_objpath = 
       (SELECT t FROM x_base_c2 AS t
            WHERE t.attr1_int_unique_idx = x_base_c1.attr1_int_unique_idx);
UPDATE x_base_c2
   SET attr16_objpath = 
       (SELECT t FROM x_base_c0 AS t
            WHERE t.attr1_int_unique_idx = x_base_c2.attr1_int_unique_idx);
SELECT * FROM x_base_c0 WHERE attr1_int_unique_idx < 5 order by 1;
SELECT * FROM x_base_c1 WHERE attr1_int_unique_idx < 5 order by 1;
SELECT * FROM x_base_c2 WHERE attr1_int_unique_idx < 5 order by 1;
COMMIT WORK;
