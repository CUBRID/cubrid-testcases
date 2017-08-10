-- create reverse unique index on table and using min,max function

create table bt(a varchar(20));
create reverse unique index ru_idx_a  on bt(a);

insert into bt values('1');
insert into bt values('2');

select min(a), max(a) from bt;

drop class bt;
