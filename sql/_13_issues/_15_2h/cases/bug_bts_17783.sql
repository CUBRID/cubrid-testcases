--+ holdcas on;
set names binary;
select 'a' || chr(0) || 'a';
select concat('a' || chr(0) || 'a');
select concat_ws(chr(0) , chr(0) , 'a');
select elt(2,chr(0),chr(0),chr(0));
select field(chr(0),chr(1),chr(0))
select bit_length(chr(0));
select char_length(chr(0));
select character_length(chr(0));
select length(chr(0));
select lengthb(chr(0));
set names iso88591;
commit;
--+ holdcas off;
