create table lob(
		col0 int AUTO_INCREMENT,
        col1 blob,
        col2 clob);
create table settable(
		col0 int AUTO_INCREMENT,
        col1 set,
        col2 multiset,
        col3 sequence);

insert into lob(col1,col2) values(bit_to_blob(B'000010'), char_to_clob('character'));
insert into lob(col1,col2)  values(bit_to_blob(B'11100010'), char_to_clob('string'));

insert into settable(col1,col2,col3) values({11, 22}, {'ghj','yut'}, {80,90,100});
insert into settable(col1,col2,col3) values({10, 20}, {'abc','def'}, {50,60,70});


--test
select col0,col1,col2, conv(col1,36,10),conv(col2,36,10) from lob order by 1;
--test
select col0,col1,col2, col3, conv(col1,36,10),conv(col2,36,10),conv(col3,36,10) from settable order by 1;



drop table lob;
drop table settable;
