drop table if exists t1,foo;
create table t1(e enum('a', 'b', 'c', 'xyz'));
insert into t1 values (1), ('b'), (3), ('xyz');

create table foo as
with cte(c) as
(
select group_concat(e order by e asc) from t1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

select * from foo;

 
with cte(c) as
(
select max(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


 
with cte(c) as
(
select min(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


insert  into foo 
with cte(c) as
(
select sum(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

select * from foo;

with cte(c) as
(
select avg(e) from t1 order by 1
) delete from foo where c>(select cast(c as varchar) from cte) ;

select * from foo;


with cte(c) as
(
select count(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select stddev(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select stddev_pop(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select var_pop(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select stddev_samp(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select var_samp(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select variance(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select ascii(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select bin(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select bit_length(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select char_length(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select character_length(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select chr(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select concat(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select concat_ws(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select elt(1, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select field(e, 'a', 'b', 'c', 'd', 'xyz') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select find_in_set(e, 'a, b, c, d, e, f, g, h') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select insert(e, 1, 2, 'xx') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select instr('abcdefgh', e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select lcase(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select left(e, 1) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select length(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select lengthb(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select locate(e, 'abcdefgh') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select lower(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select lpad(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;




with cte(c) as
(
select lower(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select ltrim(e, 'x') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select reverse(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select mid(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select replace(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select mid(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select repeat(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select position(e in e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select octet_length(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select right(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select rpad(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select rtrim(e, 'b') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select '''' + space(e)  + '''' from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select substring_index(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select substring(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select substr(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select strcmp(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select upper(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select ucase(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select '''' + trim(e from e) + '''' from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select translate(e, e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;





with cte(c) as
(
select to_char(cos(e), '9.999999') from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select substr(to_char(cot(e)),1,15) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select acos(e) from t1 where e <= 1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select abs(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select conv(e, 10, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select asin(e) from t1 where e <= 1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select ceil(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select atan2(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select degrees(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select substr(to_char(exp(e)),1,15) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c) as
(
select format(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;



with cte(c,d) as
(
select greatest(e, e, e, 2), greatest(e, e, e, 'x') from t1 order by 1, 2
)select c from cte ;



with cte(c) as
(
select greatest(e, e, e, cast(e as int)) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select hex(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c,d) as
(
select least(e, e, e, 2), least(e, e, e, 'x') from t1 order by 1, 2
)select c from cte ;


with cte(c) as
(
select least(e, e, e, cast(e as int)) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select ln(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select log2(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select log10(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select mod(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select pow(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select power(e, e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select radians(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select round(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select sign(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select sin(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select sqrt(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select tan(e)||'' from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c,d) as
(
select trunc(e, 1), trunc(12345, e) from t1 order by 1, 2
)select c from cte ;


with cte(c,d) as
(
select truncate(e, 1), truncate(12345, e) from t1 order by 1, 2
)select c from cte ;


with cte(c,d) as
(
select if (e=1, 0, e), if(e>1, e, 0) from t1 order by 1, 2
)select c from cte ;


with cte(c) as
(
select coalesce(e, e, e, 2) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c) as
(
select decode(e, e, e, 2) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c,d) as
(
    select e, case e when 1 then 10 when 2 then e when 3 then e else e end from t1 order by 1, 2
)select d from cte ;

with cte(c,d) as
(
    select e, case when cast(e as int)=1 then 10 when  cast(e as int)=2 then e when  cast(e as int)=3 then e else e end from t1 order by 1, 2
) select d from cte ;


with cte(c,d) as
(
select ifnull(e, null), ifnull(null, e) from t1 order by 1, 2
)select c from cte ;

with cte(c,d) as
(
select nullif(e, null), nullif(e, e) from t1 order by 1, 2
)select c from cte ;


with cte(c,d) as
(
select nvl(e, null), nvl(null, e) from t1 order by 1, 2
)select c from cte ;


with cte(c,d) as
(
select nvl2(e, e, e), nvl2(null, e, e) from t1 order by 1, 2
)select c from cte ;

with cte(c) as
(
select isnull(e) from t1 order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;


with cte(c) as
(
select * from t1 where e like e order by 1
)delete from foo where c>(select cast(c as varchar) from cte) limit 1 ;

with cte(c,d,f) as
(
select e, md5(e), md5(cast(e as varchar)) from t1 order by 1, 2, 3
)select f from cte ;

--drop table t1,foo;
