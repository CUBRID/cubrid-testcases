--Create trigger using obj variable

create class oo(x int);
create trigger o_in before delete on oo execute delete from oo where x = obj.x + 500;

insert into oo values (1);
insert into oo values(501);

delete from  oo;

select count(*) from oo;


drop trigger o_in;
drop oo;
