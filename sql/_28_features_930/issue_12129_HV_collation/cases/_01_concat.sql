set names iso88591;
prepare s from 'select concat (?,?), collation (concat (?,?))';
execute s using _utf8'a',_utf8'b', _utf8'a',_utf8'b';

execute s using _iso88591'a',_iso88591'b', _iso88591'a',_iso88591'b';

execute s using _euckr'a',_euckr'b', _euckr'a',_euckr'b';

execute s using _utf8'a',_euckr'b', _utf8'a',_euckr'b';

execute s using _euckr'a',_utf8'b', _euckr'a',_utf8'b';



select 'named variable';

prepare s from 'select concat(?) into :r';
execute s using _utf8'a';

select :r, collation (:r);


execute s using _iso88591'a';
select :r, collation (:r);

execute s using _euckr'a';
select :r, collation (:r);

drop variable r;
set names iso88591;
