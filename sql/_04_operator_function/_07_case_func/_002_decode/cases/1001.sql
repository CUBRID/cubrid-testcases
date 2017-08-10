--test decode operator with null value.

create class a ( aa string, bb string );
insert into a values ( null, null );
insert into a values ( '-1', '-1' );
insert into a values ( '0', '0' );
insert into a values ( '1', '1' );
insert into a values ( '3', '1' );
insert into a values ( '7', '1' );

select aa, decode ( aa, null ,'null', '-1', 'minus 1', '0', 'zero', 'plus value') from a order by 1;

select bb, decode ( bb, null ,'null', '-1', 'minus 1', '0', 'zero', 'plus value') from a order by 1;


drop class a;
