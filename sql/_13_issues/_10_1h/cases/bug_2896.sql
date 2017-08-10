create table ai (
        id integer auto_increment primary key,
        name varchar(20)
);
insert into ai(name) values('a');
create table fk (
        id integer auto_increment primary key,
        refid integer foreign key references ai(id)
                on update set null on delete set null,
        name varchar(20)
);
insert into fk(refid,name) values(1, 'aa');
update ai set id=101 where id=1;

select * from ai;
select * from fk;

drop table fk;
drop table ai;

