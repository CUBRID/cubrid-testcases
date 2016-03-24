create class xoo ( a int primary key) reuse_oid;
create class yoo ( b int,
      foreign key(b) references xoo(a) 
);

insert into xoo values(1);
insert into yoo(b) values(1);

select * from yoo;
drop yoo;
drop xoo;

create class xoo ( a int primary key)  reuse_oid;
create class yoo ( b int,
      foreign key(b) references xoo(a) on delete cascade
)reuse_oid ;

insert into xoo values(1);
insert into yoo(b) values(1);
select b from yoo;
delete from xoo;
select b from yoo;
drop yoo;
drop xoo;

