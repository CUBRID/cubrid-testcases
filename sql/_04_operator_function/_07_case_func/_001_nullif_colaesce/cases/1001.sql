--test keyword 'case', 'nullif' with a select query

create class a ( aa int, bb double );
insert into a values ( null, null );
insert into a values ( -1, -1 );
insert into a values ( 0, 0 );
insert into a values ( 1, 1 );
insert into a values ( 3, 1 );
insert into a values ( 7, 1 );

select sum(         case         when aa=1 then bb*1         when aa=3 then bb*2         when aa=7 then bb*3         end ) from a where aa in { 1,3,7} order by 1;
select sum(         case         when aa=(select aa from a where aa=1) then bb*1         when aa=(select aa from a where aa=3) then bb*2         when aa=(select aa from a where aa=7) then bb*3         end ) from a where aa in { 1,3,7} order by 1;
select ( case         when aa = 1 then bb         else ( case when aa = 2 then bb end )         end         ) from a order by 1;
select case when aa is null then 0 else aa end from A order by 1;
select coalesce(aa, 0) from A order by 1;
select nullif(aa,bb) from A  order by 1;
select ( case when aa = bb then null else aa end ) from A order by 1;

drop class a;
