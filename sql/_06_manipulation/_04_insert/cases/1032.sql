set system parameters 'create_table_reuseoid=no';
--Test nested insert with list partition

create class person(name varchar(20), age integer , gender char(1));
create class substation (
    line_id   varchar(10)  not null,
    station_id    integer,
    person person
)
partition by hash (station_id)
partitions 4
;


insert into substation values ('Line 1', 1021, (insert into person values ('xxx', 21, 'f')));
insert into substation values ('Line 1', 1031, (insert into person values ('xxx', 21, 'f')));


drop class substation;
drop class person;
set system parameters 'create_table_reuseoid=yes';
