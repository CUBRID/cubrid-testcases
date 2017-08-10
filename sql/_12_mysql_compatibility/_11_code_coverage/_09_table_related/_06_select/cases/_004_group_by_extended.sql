-- Extended GROUP BY (with hidden columns)

create table emp(id integer,firstname varchar(80),lastname varchar(80));

insert into emp values(1,'Weeller','John'),(7,'Higurashi','Manta'),(8,'Weeller','Bill'),(1,'Smith','John'),(2,'Brown','Charles'),(7,'Higurashi','Manta'),(8,'Weeller','Bill'),(7,'Higurashi','Manta'),(8,'Weeller','Bill'),(7,'Higurashi','Manta'),(8,'Weeller','Bill');

select firstname,lastname,count(*) from emp group by firstname, lastname;

select firstname,lastname,count(*) from emp group by firstname order by firstname, lastname desc limit 3;

drop table emp;
