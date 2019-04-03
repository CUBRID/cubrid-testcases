-- regular expression syntax tests (prepared statements)
set @decoy = 'a';
set @intg = 123;
set @num = 123.45;
set @nao = now();
set @bf = b'1001';
set @a = '^a$';

prepare rlike_st from 'select (? rlike ?)';

execute rlike_st using @decoy, @a;
execute rlike_st using @intg, @intg;
execute rlike_st using @num, @num;
execute rlike_st using @nao, @nao;
execute rlike_st using @bf, @bf;

execute rlike_st using @decoy, null;
execute rlike_st using null, @decoy;
execute rlike_st using null, null;

execute rlike_st using @decoy, '';
execute rlike_st using '', @decoy;
execute rlike_st using '', '';

execute rlike_st using '', null;
execute rlike_st using null, '';

execute rlike_st using 'a', @a;
execute rlike_st using 'aa', @a;
execute rlike_st using 'b', @a;
DROP VARIABLE @a,@decoy,@intg,@num, @nao,@bf;

set @a_any = '^a*';
execute rlike_st using '', @a_any;
execute rlike_st using 'a', @a_any;
execute rlike_st using 'aaa', @a_any;
execute rlike_st using 'aaab', @a_any;
execute rlike_st using 'abcdef', @a_any;
execute rlike_st using 'b', @a_any;
execute rlike_st using 'bbba', @a_any;
DROP VARIABLE @a_any;

set @a_plus = '^a+';
execute rlike_st using 'a', @a_plus;
execute rlike_st using 'aaa', @a_plus;
execute rlike_st using 'aaab', @a_plus;
execute rlike_st using 'abcdef', @a_plus;
execute rlike_st using '', @a_plus;
execute rlike_st using 'b', @a_plus;
execute rlike_st using 'bbba', @a_plus;
DROP VARIABLE @a_plus;

set @a_qmark = '^a?$';
execute rlike_st using '', @a_qmark;
execute rlike_st using 'a', @a_qmark;
execute rlike_st using 'aa', @a_qmark;
execute rlike_st using 'ab', @a_qmark;
execute rlike_st using 'b', @a_qmark;
execute rlike_st using 'ba', @a_qmark;
DROP VARIABLE @a_qmark;

set @a_something = '^a.+$';
execute rlike_st using 'ax', @a_something;
execute rlike_st using 'a#', @a_something;
execute rlike_st using 'abcdef', @a_something;
execute rlike_st using '', @a_something;
execute rlike_st using 'a', @a_something;
execute rlike_st using 'bacdef', @a_something;
DROP VARIABLE @a_something;

set @ab_or_ba_something = '^(ab|ba).+$';
execute rlike_st using 'abc', @ab_or_ba_something;
execute rlike_st using 'bac', @ab_or_ba_something;
execute rlike_st using 'abxyz', @ab_or_ba_something;
execute rlike_st using 'baxyz', @ab_or_ba_something;
execute rlike_st using 'ab', @ab_or_ba_something;
execute rlike_st using 'ba', @ab_or_ba_something;
execute rlike_st using 'acx', @ab_or_ba_something;
execute rlike_st using 'xyz', @ab_or_ba_something;
DROP VARIABLE @ab_or_ba_something;

set @ab_more = '^(ab)+$';
execute rlike_st using 'ab', @ab_more;
execute rlike_st using 'abab', @ab_more;
execute rlike_st using 'ababab', @ab_more;
execute rlike_st using '', @ab_more;
execute rlike_st using 'bababa', @ab_more;
execute rlike_st using 'abxb', @ab_more;
execute rlike_st using 'a', @ab_more;
DROP VARIABLE @ab_more;

set @a_3_to_5 = '^a{3,5}$';
execute rlike_st using 'aaa', @a_3_to_5;
execute rlike_st using 'aaaa', @a_3_to_5;
execute rlike_st using 'aaaaa', @a_3_to_5;
execute rlike_st using '', @a_3_to_5;
execute rlike_st using 'a', @a_3_to_5;
execute rlike_st using 'aa', @a_3_to_5;
execute rlike_st using 'aaaaaa', @a_3_to_5;
execute rlike_st using 'aaaaaaa', @a_3_to_5;
execute rlike_st using 'baaaab', @a_3_to_5;
DROP VARIABLE @a_3_to_5;

set @range_1 = '^[abc]+$';
execute rlike_st using 'a', @range_1;
execute rlike_st using 'b', @range_1;
execute rlike_st using 'c', @range_1;
execute rlike_st using 'abc', @range_1;
execute rlike_st using 'cbac', @range_1;
execute rlike_st using 'baca', @range_1;
execute rlike_st using 'd', @range_1;
execute rlike_st using 'abcd', @range_1;
execute rlike_st using 'adcba', @range_1;
DROP VARIABLE @range_1;

set @range_2 = '^[a-cx]+$';
execute rlike_st using 'a', @range_2;
execute rlike_st using 'b', @range_2;
execute rlike_st using 'c', @range_2;
execute rlike_st using 'x', @range_2;
execute rlike_st using 'abcx', @range_2;
execute rlike_st using 'cbaxc', @range_2;
execute rlike_st using 'xbaca', @range_2;
execute rlike_st using 'd', @range_2;
execute rlike_st using 'abcd', @range_2;
execute rlike_st using 'aycba', @range_2;
DROP VARIABLE @range_2;

set @range_3 = '^[^a-w]+$';
execute rlike_st using 'xyz', @range_3;
execute rlike_st using '123', @range_3;
execute rlike_st using '!@#', @range_3;
execute rlike_st using '', @range_3;
execute rlike_st using 'xyza', @range_3;
execute rlike_st using 'wxyz', @range_3;
DROP VARIABLE  @range_3;

set @tilde = '^[[.tilde.]]$';
execute rlike_st using '~', @tilde;
execute rlike_st using '', @tilde;
execute rlike_st using 'a', @tilde;
execute rlike_st using '1', @tilde;
execute rlike_st using '!', @tilde;
DROP VARIABLE @tilde;

set @word_fox = '\bfox\b';
execute rlike_st using 'I have a fox', @word_fox;
execute rlike_st using 'fox has a human', @word_fox;
execute rlike_st using 'any human and fox can live peacefully', @word_fox;
execute rlike_st using '', @word_fox;
execute rlike_st using 'nofox here', @word_fox;
execute rlike_st using 'lady is foxy', @word_fox;
execute rlike_st using 'the foxx is not an animal', @word_fox;
DROP VARIABLE @word_fox;
deallocate prepare rlike_st;

