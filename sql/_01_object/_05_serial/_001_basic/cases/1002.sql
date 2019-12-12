--test serial using 'start with', 'increment by' clause and many insert statements with 'next_value' attribute
create class cnf_1( 
	col1 int,
	col2 int,
	col3 int,
	col4 int,
	col5 int );


create serial cnf_col1
	start with 1;
create serial cnf_col2
	start with 1
	increment by 2;
create serial cnf_col3
	start with 10
	increment by 3;
create serial cnf_col4
	start with 100000
	increment by -1;
create serial cnf_col5
	start with 100000
	increment by -3;
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
insert into cnf_1 values( cnf_col1.next_value, cnf_col2.next_value, cnf_col3.next_value, cnf_col4.next_value, cnf_col5.next_value );
select col1, col2, col3, col4, col5
from cnf_1
where col1 in ( select col1 from cnf_1 where not ( col2 > 10 and col1 < 40 ) )
order by 1,2,3,4,5;

select col1, col2, col3, col4, col5
from cnf_1
where col1 in ( select col1 from cnf_1 where col1 <= 10 or col1 >= 40 )
order by 1,2,3,4,5;


select col1, col2, col3, col4, col5
from cnf_1
order by 1,2,3,4,5;



drop serial cnf_col1;
drop serial cnf_col2;
drop serial cnf_col3;
drop serial cnf_col4;
drop serial cnf_col5;
drop class cnf_1;
