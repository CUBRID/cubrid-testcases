-- retrieve by function of trim using string parameter contains letters,Korean and using keywords for example "leading","trailing","both"


create class dummy( a int );
insert into dummy values (1);


select trim(' ''h''i    ') from dummy	;
select trim('hi') from dummy	;
select trim(null) from dummy	;
select trim(' hihi ') from dummy	;
select trim(' ' from '  hihi haha ') from dummy	;
select trim(' ' from null) from dummy	;
select trim('  hi hi ') from dummy	;
select trim(leading ' ' from '  hi hi ') from dummy	;
select trim(trailing ' i' from '  hi hi ') from dummy	;
select trim(both ' ' from '  hi hi ') from dummy	;
select trim(leading '? ' from '  hi hi ') from dummy	;
select trim(trailing '?' from '  hi hi ') from dummy	;
select trim(both '? ' from '  hi hi ') from dummy;

drop class dummy;