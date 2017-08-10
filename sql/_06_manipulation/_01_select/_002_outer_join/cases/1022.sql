--Test left and right outer join 

create class o1 ( id char(3));
create class o2 ( id char(3));
create class o3 ( id char(3), id1 char(3));

insert into o1 values('1');
insert into o3 values('1', null);

select * from (
  select nvl(o2.id, '100') st from
     o1 left outer join o2 on o1.id = o2.id
) x where st like '100';

select * from (
  select nvl(o2.id, '100') st from
     o1 left outer join o2 on o1.id = o2.id
) x;

select * from (
  select coalesce(o2.id, '100') st from
     o1 left outer join o2 on o1.id = o2.id
) x where st like '100';

select * from (
  select nvl(o2.id, '100') st from
     o2 right outer join o1 on o1.id = o2.id
) x where st like '100';

select * from (
  select nvl(o2.id, '100') st from
     o2 right outer join o1 on o1.id = o2.id
) x;

select * from (
  select coalesce(o2.id, '100') st from
     o2 right outer join o1 on o1.id = o2.id
) x where st like '100';

select * from (
  select nvl(o3.id1, '100') st from
     o1 left outer join o3 on o1.id = o3.id
) x where st like '100';

select * from (
  select nvl(o3.id1, '100') st from
     o1 left outer join o3 on o1.id = o3.id
) x;

select * from (
  select coalesce(o3.id1, '100') st from
     o1 left outer join o3 on o1.id = o3.id
) x where st like '100';

select * from (
  select nvl(o3.id1, '100') st from
     o1 left outer join (select * from o3 where id = '10') o3 on o1.id = o3.id
) x where st like '100';

select * from (
  select nvl(o3.id1, '100') st from
     o1 left outer join (select * from o3 where id = '10') o3 on o1.id = o3.id
) x;

select * from (
  select nvl(o3.id1, '100') st from
     o1 left outer join (select * from o3 where id = '10') o3 on o1.id = o3.id
) x where st like '100';


drop table o1;
drop table o2;
drop table o3;
