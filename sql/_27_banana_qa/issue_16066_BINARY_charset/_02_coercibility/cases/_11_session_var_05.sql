--+ holdcas on;

--[I18N] The coercibility of expressions having host variable arguments are incorrect.

set names binary;

prepare st1 from 'select collation(upper(?)) collation, coercibility(upper(?)) coeribility';
prepare st2 from 'select collation(concat(?, ?)) collation, coercibility(concat(?, ?)) coercibility';
prepare st3 from 'select collation(reverse(?)) collation, coercibility(reverse(?)) coercibility';
prepare st4 from 'select /*+ recompile */collation(replace(?, ?, ''b'')) collation, coercibility(replace(?, ?, ''b'')) coercibility';
prepare st5 from 'select collation(lpad(?, 30, ?)) collation, coercibility(lpad(?, 30, ?)) coercibility';
prepare st6 from 'select collation(repeat(?, 3)) collation, coercibility(repeat(?, 3)) coercibility';
prepare st7 from 'select collation(elt(?, ?, ?)) collation, coercibility(elt(?, ?, ?)) coercibility';
prepare st8 from 'select collation(trim(?)) collation, coercibility(trim(?)) coercibility';


set names binary;
execute st1 using 'a', 'a';
execute st2 using 'a', 'b', 'a', 'b';
execute st3 using 'b', 'b';
execute st4 using 'abc', 'a', 'abc', 'a';
execute st5 using '123', 12.3, '123', 12.3;
execute st6 using 'a', 'a';
execute st7 using 2, '1', 2, 2, '1', 2;
execute st8 using '  a  ', '  a  ';
select collation(upper('a')) collation, coercibility(upper('a')) coeribility;

set names iso88591;
commit;
--+ holdcas off;

