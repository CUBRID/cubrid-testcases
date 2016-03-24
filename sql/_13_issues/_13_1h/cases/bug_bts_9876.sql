--TEST: [I18N] show collation doesn't support filtered with "collation"


show collation where charset='utf8';
show collation where built_in='Yes';
show collation where expansions='No';
show collation where strength='Not applicable';

--filter with 'collation'
show collation where collation='utf8_bin';
show collation where collation like '%fr%';
show collation where collation in ('iso88591_en_ci', 'utf8_fr_exp_ab', 'utf8_ko_cs');
show collation where collation is not null;
show collation where collation = any{'euckr_bin', 'utf8_ja_exp_cbm', 'utf8_km_exp'};
show collation where collation between 'e' and 'u';


