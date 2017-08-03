SELECT COS(0) from db_root;
SELECT to_char(COS(1), '9.999999') from db_root;
SELECT to_char(COS(-1), '9.999999') from db_root;
SELECT COS(PI()) from db_root;
SELECT to_char(COS(PI()*pi()), '9.999999999') from db_root;
SELECT to_char(9223372036854775807, '9.999EEEE') from db_root;
SELECT to_char(-9223372036854775807, '9.999EEEE') from db_root;
SELECT to_char(COS(COS(COS(COS(COS(COS(COS(COS(COS(1))))))))), '9.999999999') from db_root;
