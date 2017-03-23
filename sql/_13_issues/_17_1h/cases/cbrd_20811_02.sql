drop if exists h;
create table h (id integer, parent_id integer);
insert into h values
(1, null), (2, 1), (3, 1),(4, 3), (5, 4), (3, 5); 

with recursive tree as (
  select id, 
         parent_id
  from h where parent_id is null
  union all
  select c.id, 
         c.parent_id
  from h c
       inner join tree p
       on c.parent_id = p.id  and c.id<>3
)
select * from tree order by 1,2;

with recursive tree as (
  select id, 
         parent_id
  from h where parent_id is null
  union all
  select c.id, 
         c.parent_id
  from h c
       inner join tree p
       on c.parent_id = p.id
)
select * from tree order by 1,2;
drop if exists h;
