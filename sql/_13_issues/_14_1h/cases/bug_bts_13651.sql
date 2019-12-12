--[I18N] Results are inconsistent in 'IN' expression with HV arguments when the binding data or the binding order is different.

set names iso88591;

drop table if exists t;
create table t(a int);
insert into t values(1);

prepare st from 'select * from t where ? in (?, ?)';

--error occurs
execute st using 'b', _euckr'a', 'a';
--no error ('a' -> 'b')
execute st using 'b', _euckr'a', 'b';
--error occurs (change binding order)
execute st using 'b', 'b', _euckr'a';

deallocate prepare st;

drop table t;

set names iso88591;



