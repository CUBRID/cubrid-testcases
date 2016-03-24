autocommit off;
delete from employees_v where ssn = 654654645;
delete from employees_v
where location in (select location
                       from all inventory_v                                   
                      where product_code = 1
                         or product_code = 2);

create class ffoo (c int);
insert into ffoo (c) values (5);
delete from ffoo where foo.c = 5;
select * from ffoo where foo.c = 5;
create class set_attr
	(
		se_instance	int,
		se_small_int	sequence of smallint,
		se_int		sequence of int,
		se_float	sequence of float,
		se_double	sequence of double,
		se_char_10	sequence of char(10),
		se_string	sequence of string,
		se_time		sequence of time,
		se_timestamp	sequence of timestamp,
		se_date		sequence of date,
		se_monetary	sequence of monetary,
		se_object	sequence of object,
		se_set_attr	set_attr,
		se_all		sequence of ()
	);
		
insert into set_attr(se_instance, se_int)
	values(1, sequence{1,2,3,4,5,6,7,8,9,0}) to s1;
insert into set_attr(se_instance, se_set_attr)
	values(10000, s1);
delete from set_attr where se_int = sequence{1,2,3,4,5,6,7,8,9,0};
/* Boom */
rollback;
