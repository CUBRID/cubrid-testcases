--+ holdcas on;

--[I18N] The coercibility of expressions having host variable arguments are incorrect.

set names binary;

prepare st1 from 'select collation(upper(?)) collation, coercibility(upper(?)) coeribility';
execute st1 using 'a', 'a';
deallocate prepare st1;

prepare st2 from 'select collation(concat(?, ?)) collation, coercibility(concat(?, ?)) coercibility';
execute st2 using 'a', 'b', 'a', 'b';
deallocate prepare st2;

prepare st3 from 'select collation(reverse(?)) collation, coercibility(reverse(?)) coercibility';
execute st3 using 'b', 'b';
deallocate prepare st3;

prepare st4 from 'select /*+ recompile */collation(replace(?, ?, ''b'')) collation, coercibility(replace(?, ?, ''b'')) coercibility';
execute st4 using 'abc', 'a', 'abc', 'a';
deallocate prepare st4;

prepare st5 from 'select collation(lpad(?, 30, ?)) collation, coercibility(lpad(?, 30, ?)) coercibility';
execute st5 using '123', 12.3, '123', 12.3;
deallocate prepare st5;

prepare st6 from 'select collation(repeat(?, 3)) collation, coercibility(repeat(?, 3)) coercibility';
execute st6 using 'a', 'a';
deallocate prepare st6;

prepare st7 from 'select collation(elt(?, ?, ?)) collation, coercibility(elt(?, ?, ?)) coercibility';
execute st7 using 2, '1', 2, 2, '1', 2;
deallocate prepare st7;

prepare st8 from 'select collation(trim(?)) collation, coercibility(trim(?)) coercibility';
execute st8 using '  a  ', '  a  ';
deallocate prepare st8;

select collation(upper('a')) collation, coercibility(upper('a')) coeribility;

set names iso88591;
commit;
--+ holdcas off;
