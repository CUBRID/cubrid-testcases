autocommit off;
create class mother ( myself mother );
create class son as subclass of mother ( myself son );
drop son, mother;
rollback;
