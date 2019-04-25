set @jdoc='{"name":"Lily", "age":12, "hobbies":["Reading","Watching movies","Play tennis"]}';
set @jobj='{"hobbies":["drawing"], "grade":5}';
set @jarr='["flower arrangement","swimming"]';
set @int1 = 1;
set @str1 = '1';
set @b1_true='true', @b2_false='false', @b3_TRUE='TRUE', @b3_FALSE='FALSE', @b5_True='True';
set @n1_null='null', @n1_NULL=NULL;
set @empty_str='';

prepare st from 'select json_depth(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_length(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_keys(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_get_all_paths(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_quote(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
--CBRD-22651(case 7, by design)
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_unquote(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
-- CBRD-22545 following four qureies have different results with MySQL. (by design)
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @empty_str;
execute st using @n1_null;
execute st using @n1_NULL;

prepare st from 'select json_pretty(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_valid(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_type(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select json_arrayagg(?);';
execute st using @jdoc;
execute st using @jobj;
execute st using @jarr;
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

prepare st from 'select * from json_table(?, ''$'' 
columns(
    name varchar(20) path ''$.name'',
    age int path ''$.age'',
    hobbies varchar(200) path ''$.hobbies''
)) as student;';
select @jdoc;
execute st using @jdoc;
select @jobj;
execute st using @jobj;
select @jarr;
execute st using @jarr;
--CBRD-22672
execute st using @int1;
execute st using @str1;
execute st using @b1_true;
execute st using @b2_false;
execute st using @b3_TRUE;
execute st using @b3_FALSE;
execute st using @b5_True;
execute st using @n1_null;
execute st using @n1_NULL;
execute st using @empty_str;

drop prepare st;
drop variable @jdoc, @jobj, @jarr, @int1, @str1, @b1_true, @b2_false;
drop variable @b3_TRUE, @b3_FALSE, @b5_True, @n1_null, @n1_NULL, @empty_str;
