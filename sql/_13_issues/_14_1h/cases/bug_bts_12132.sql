--[I18N] In database with euckr charset, error occurs when comparing two session variables while one of them is assigned value with host variable.


set names euckr;

prepare s from 'select CONCAT (?) into :result';
execute s using 'aaa';

evaluate 'aaa' into :expected;

select :result=:expected;

select collation(:result);
select collation(:expected);

--error should occur
select :result = _utf8'aaa';

execute s using _utf8'aaa';
select :result, collation(:result);

set names utf8;
execute s using _iso88591'abc';
select :result, collation(:result);


deallocate prepare s;
drop variable result, expected;

set names iso88591;
