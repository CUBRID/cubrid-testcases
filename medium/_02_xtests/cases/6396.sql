autocommit off;
create class bit_class (int_attr integer, 
                        bit_attr bit(32),
                        varbit_attr bit varying(32));
insert into bit_class values (1, 
                              B'01010101010101010101010101010101',
                              B'10101010101010101010101010101010');
select octet_length(bit_attr) from bit_class where int_attr = 1;
select octet_length(varbit_attr) from bit_class where int_attr = 1;
rollback;
