select TRIM('foo' FROM 'foo'), TRIM('foo' FROM 'foook'), TRIM('foo' FROM 'okfoo');
select TRIM('fo' FROM 'aasdfoo');   

select trim('/' from '/abcd//\/');
select trim(both '/' from '/abcd//\/');
select trim(leading '/' from '/abcd//\/');
select trim(trailing '/' from '/abcd//\/');


--insert
create table foo(a varchar);
insert into foo values(trim('/' from '/abcd//\/'));

prepare st from 'insert into foo values (trim(? from ?));';
execute st using '/', '/abcd//\/';
deallocate prepare st;

--error
prepare st from 'insert into foo values (?);';
execute st using trim('/' from '/abcd//\/');
deallocate prepare st;


select case when count(*)=2 then 'ok' else 'nok' end from foo where a='abcd//\';


--update
update foo set a=trim('\' from a);
select if(a='abcd//', 'ok', 'nok') from foo;

prepare st from 'update foo set a=trim(? from ?)';
execute st using ' abc ', ' abc  abcabcabcabc  abc ';
deallocate prepare st;
select if(a=' abcabcabcabc ', 'ok', 'nok') from foo;

update foo set a=trim(leading ' ' from a);
select if(a='abcabcabcabc ', 'ok', 'nok') from foo;
update foo set a=trim(trailing ' ' from a);
select if(a='abcabcabcabc', 'ok', 'nok') from foo;


--where clause
prepare st from 'delete from foo where trim(? from a)=?;';
execute st using 'abc', '';
deallocate prepare st;

select if(count(*)=0, 'ok', 'nok') from foo;


drop table foo;
