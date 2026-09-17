-- CBRD-27043: db_histogram column domains -- class_name is a string, not an object,
-- and null_frequency is NUMERIC(18,12) as the view spec casts it
select attr_name, data_type, prec, scale from db_attribute where class_name = 'db_histogram' order by def_order;
