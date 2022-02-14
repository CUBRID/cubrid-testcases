autocommit off;
create class dummy( a string );
insert into dummy values (null);
select char_length(a) from dummy;  --??
select bit_length(a) from dummy;  --??
select octet_length(a) from dummy;  --??
select position(a in a) from dummy;
select position(a in 'hihi') from dummy;
select substring(a from 1) from dummy;
select lower(a) from dummy;
select upper(a) from dummy;
select char_length(null) from dummy;
select bit_length(null) from dummy;
select octet_length(null) from dummy;
select position(null in  null) from dummy;
select position(null in ' hihi ') from dummy;
select substring(null from null) from dummy;
select substring(null from 1) from dummy;
select lower(null) from dummy;
select upper(null) from dummy;
rollback work;
rollback;
