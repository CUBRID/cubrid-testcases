--+ holdcas on;
-- prm_get_next_param_value
set system parameters ' default_week_format = 3  ;  compat_mode =  invalid_compat_mode';
set system parameters 'default_week_format';
set system parameters 'default_week_format ';
set system parameters 'default_week_format =';
set system parameters 'default_week_format = ';
set system parameters 'default_week_format = "3';
set system parameters 'default_week_format="\3';
set system parameters 'default_week_format="\\3';
set system parameters ' default_week_format = 3  ;  compat_mode ';
-- sysprm_prm_change_should_clear_cache 
set system parameters 'dwf=0';

-- back to defaults
set system parameters 'default_week_format=0';
set system parameters 'compat_mode=cubrid';


commit;
--+ holdcas off;
