autocommit off;
create class set_attr
(
        se_object       set(object),
        se_obj_char     set( set_attr, string)
        );
insert into set_attr values({},{})	to s2;
select * from set_attr;
update set_attr
set
se_object = se_object + {s2},
se_obj_char = se_obj_char + {'new stuff 3',s2}
select * from set_attr;
rollback;
