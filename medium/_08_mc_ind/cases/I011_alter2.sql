autocommit off;
ALTER CLASS x_base_c1
      ADD ATTRIBUTE tmp_attr1 integer,
                    tmp_attr2 integer;
ALTER CLASS x_base_c1
      DROP ATTRIBUTE attr3_smallint_noidx, attr4_float_noidx;
SELECT * FROM x_base_c1 WHERE attr1_int_unique_idx < 5 order by 1;
ROLLBACK WORK;
SELECT * FROM x_base_c1 WHERE attr1_int_unique_idx < 5 order by 1;
ROLLBACK WORK;
