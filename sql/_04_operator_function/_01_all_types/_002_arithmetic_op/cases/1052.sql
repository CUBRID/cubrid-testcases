--test the data overflow error in update query using the operator '+' with a constant

create class foo (c char(5)); 
insert into foo values ('1') ;
insert into foo values ('1') ;

update foo set c = trim('1') || '23' where c = '1';
update foo set c = trim('1') + '23' where c = '2';

select * from foo order by 1;

drop foo;
