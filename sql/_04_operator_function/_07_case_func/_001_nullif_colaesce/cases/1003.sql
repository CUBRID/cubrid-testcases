--[er]'coalesce' with varchar

create class a ( aa string, bb string );
insert into a values ( null, null );
insert into a values ( '-1', '-1' );
insert into a values ( '0', '0' );
insert into a values ( '1', '1' );
insert into a values ( '3', '1' );
insert into a values ( '7', '1' );

select coalesce(aa, 0) from A order by 1;

drop class a;
