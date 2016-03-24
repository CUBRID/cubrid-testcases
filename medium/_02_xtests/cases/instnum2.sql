autocommit off;
create class city (name string, pop integer);
create class state (name string, cities set of city);
insert into state (name, cities)
    values ('ohio',{
                   insert into city (name, pop) values ('cinn', 1000),
                   insert into city (name, pop) values ('columbus', 1100)}
       )
    to :st_ohio ;
insert into state (name, cities)
    values ('new hampshire', {
                   insert into city (name, pop) values ('manchester', 300),
                   insert into city (name, pop) values ('merrimack', 22)}
       )
    to :st_nh;
select rownum, st.name
from state st, TABLE (st.cities) as T(ci)
where rownum in (1,2, 3)  order by 1,2;

rollback;
