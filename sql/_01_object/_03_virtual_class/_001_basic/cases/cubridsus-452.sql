--To test view using index
create table put(
ID integer,
name varchar(10),
wddehaa varchar(100),
primary key(ID)
);

CREATE index idx on put(id,name);
create reverse index ri_put_id_name on put(id,name);

create view v_put as select * from put;

select * from v_put
where id=1 using index ri_put_id_name;

drop table put;
drop view v_put;