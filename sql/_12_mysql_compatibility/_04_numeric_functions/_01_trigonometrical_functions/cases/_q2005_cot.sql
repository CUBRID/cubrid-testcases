SELECT COT(0) from db_root;
SELECT to_char(COT(1),'9.9999999EEEE') from db_root;
SELECT to_char(COT(-1),'9.9999999EEEE') from db_root;
SELECT to_char(COT(PI()),'9.999EEEE') from db_root;
SELECT to_char(COT(COT(COT(COT(COT(COT(1)))))),'9.9999999EEEE') from db_root;
SELECT to_char(COT(COS(1)), '9.999999999') from db_root;
