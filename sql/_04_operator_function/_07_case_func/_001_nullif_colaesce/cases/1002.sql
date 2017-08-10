--test keywords 'case','coalesce', 'decode' with some select queries.

create class a ( aa string, bb string );
insert into a values ( null, null );
insert into a values ( '-1', '-1' );
insert into a values ( '0', '0' );
insert into a values ( '1', '1' );
insert into a values ( '3', '1' );
insert into a values ( '7', '1' );


select max(         case         when aa='1' then bb         when aa='3' then bb         when aa='7' then bb         end ) from a order by 1;
select case when aa is null then '0' else aa end from A order by 1;
select coalesce(aa, '0') from A order by 1;
select nullif(aa,bb) from A order by 1;
 select ( case when aa = bb then null else aa end ) from A;
select coalesce(aa, aa) from A order by 1;
select coalesce(aa,'1', '00') from A order by 1;
select coalesce({1,2,3},{}) from A order by 1;
select coalesce(null,{}) from A order by 1;
select nullif({1,2,3},{1,2,3}) from A order by 1;
select nullif({1,2,3},{}) from A order by 1;

drop table a;
