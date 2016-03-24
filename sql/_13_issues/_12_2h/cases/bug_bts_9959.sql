set names utf8;

select 'a' collate utf8_en_ci;
select _utf8'a' collate utf8_en_ci;
select _iso88591'a' collate utf8_en_ci;
select 'a' collate iso88591_en_ci;
select _utf8'a' collate iso88591_en_ci;
select _iso88591'a' collate iso88591_en_ci;

set names iso88591;

select 'a' collate utf8_en_ci;
select _utf8'a' collate utf8_en_ci;
select _iso88591'a' collate utf8_en_ci;
select 'a' collate iso88591_en_ci;
select _utf8'a' collate iso88591_en_ci;
select _iso88591'a' collate iso88591_en_ci;
