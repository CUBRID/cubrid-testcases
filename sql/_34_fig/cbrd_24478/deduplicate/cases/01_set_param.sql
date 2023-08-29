-- System parameters
/* Fail */
set system parameters 'deduplicate_key_level=-2';
set system parameters 'deduplicate_key_level=15';
/* Success */
set system parameters 'deduplicate_key_level=-1';
set system parameters 'deduplicate_key_level=0';
set system parameters 'deduplicate_key_level=1';
set system parameters 'deduplicate_key_level=14';

/* Fail */
set system parameters 'print_index_detail=haha';
/* Success */
set system parameters 'print_index_detail=0';
set system parameters 'print_index_detail=1';
set system parameters 'print_index_detail=y';
set system parameters 'print_index_detail=n';
set system parameters 'print_index_detail=yes';
set system parameters 'print_index_detail=no';
set system parameters 'print_index_detail=on';
set system parameters 'print_index_detail=off';
