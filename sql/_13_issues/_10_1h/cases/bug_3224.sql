select '(' || cast('06/01/2010' as datetime) || ')';
select '(' || cast('21:50:00 06/01/2010' as datetime) || ')';
select '(' || cast('21:50:00.123 06/01/2010' as datetime) || ')'; 

select char_length (cast(cast(sysdate as datetime) as string));
select char_length (cast(cast(systimestamp as datetime) as string));
select char_length (cast(cast(sysdatetime as datetime) as string));


