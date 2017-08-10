-- group_concat bit,var bit 

create table tab1 (poke bit(10), peek bit varying);
insert into tab1 values ( b'1101',b'110111101101');
insert into tab1 values ( b'1101',b'110111101101');
insert into tab1 values ( b'0011',b'0011011101101101');
insert into tab1 values ( NULL ,b'110111101101');
insert into tab1 values ( b'0011',NULL);
insert into tab1 values ( b'11010110',b'110111101101');
insert into tab1 values ( b'11011011',b'0011011101101101');
insert into tab1 values ( b'01111010',b'1101111011011010');
insert into tab1 values ( b'11101110',b'0011011101101101');
insert into tab1 values ( b'0110',b'110111101101');
insert into tab1 values ( b'11110001',b'00110111011011011101');

select poke,peek from tab1 order by 1, 2;

select group_concat(poke order by 1) from tab1 order by 1;

select group_concat(all poke order by 1) from tab1 order by 1;

select group_concat(distinct poke order by 1) from tab1 order by 1;

select group_concat(unique poke order by 1 desc) from tab1 order by 1;

select peek,group_concat(poke order by 1) from tab1 group by peek;

select peek,group_concat(all poke order by 1) from tab1 group by peek;

select peek,group_concat(distinct poke order by 1) from tab1 group by peek;

select peek,group_concat(unique poke order by 1) from tab1 group by peek;

select poke,group_concat(poke order by 1) from tab1 group by poke;

select poke,group_concat(all poke order by 1) from tab1 group by poke;

select poke,group_concat(distinct poke order by 1) from tab1 group by poke;

select poke,group_concat(unique poke order by 1 desc) from tab1 group by poke;

select poke,group_concat(peek order by 1) from tab1 group by poke;

select poke,group_concat(all peek order by 1) from tab1 group by poke;

select poke,group_concat(distinct peek order by 1) from tab1 group by poke;

select poke,group_concat(unique peek order by 1 desc) from tab1 group by poke;


select group_concat(poke  order by 1 separator b'000111000') from tab1 order by 1;

select group_concat(all poke order by 1 separator b'000111000') from tab1 order by 1;

select group_concat(distinct poke order by 1 separator b'000111000') from tab1 order by 1;

select group_concat(unique poke order by 1 separator b'000111000') from tab1 order by 1;

select peek,group_concat(poke order by 1 separator b'000111000') from tab1 group by peek;

select peek,group_concat(all poke order by 1 desc separator b'000111000') from tab1 group by peek;

select peek,group_concat(distinct poke order by 1 separator b'000111000') from tab1 group by peek;

select peek,group_concat(unique poke order by 1 desc separator b'000111000') from tab1 group by peek;

select poke,group_concat(poke order by 1 separator b'000111000') from tab1 group by poke;

select poke,group_concat(all poke order by 1 desc separator b'000111000') from tab1 group by poke;

select poke,group_concat(distinct poke order by 1 separator b'000111000') from tab1 group by poke;

select poke,group_concat(unique poke order by 1 desc separator b'000111000') from tab1 group by poke;

select poke,group_concat(peek order by 1 separator b'000111000') from tab1 group by poke;

select poke,group_concat(all peek order by 1 desc separator b'000111000') from tab1 group by poke;

select poke,group_concat(distinct peek order by 1 separator b'000111000') from tab1 group by poke;

select poke,group_concat(unique peek order by 1 desc separator b'000111000') from tab1 group by poke;

drop table tab1;

