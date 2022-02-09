--+ holdcas on;
SELECT IF('1'<>0, 'T', 'F');

prepare x from 'select if(?<>0, ''T'', ''F'')';
execute x using '1';
drop prepare x;

select '1' into :x;

select right('abc', :x);

prepare a from 'select right(?, :x)';
execute a using 'abc';
drop prepare a;

prepare a from 'select right(?, ?)';
execute a using 'abc', :x;
drop prepare a;


--+ holdcas off;
