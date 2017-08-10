--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : bigint , not type change 
-- other : testing tables and attributes with reserved names


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table [from] ( [where] bigint );
insert into [from] values (0),(1),(NULL),(-9223372036854775808),(9223372036854775807); 
select * from [from] order by 1;
show columns in [from];

alter table [from] change [where] [alter] bigint not NULL;

select * from [from] order by 1;
show columns in [from];

-- should fail:
insert into [from] values (NULL);

drop table [from];


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table [from] ( [insert] bigint);
insert into [from] values (0),(1),(NULL),(-9223372036854775808),(9223372036854775807); 
select * from [from] order by 1;
show columns in [from];

alter table [from] change [insert] [insert] bigint not NULL;

select * from [from] order by 1;
show columns in [from];

-- should fail:
insert into [from] values (NULL);

drop table [from];



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table [from] ( [alter] bigint );
insert into [from] values (11),(0),(-9223372036854775808),(9223372036854775807); 
select * from [from] order by 1;
show columns in [from];

alter table [from] change [alter] [alter] bigint not NULL;

select * from [from] order by 1;
show columns in [from];

-- should fail:
insert into [from] values (NULL);

drop table [from];

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
