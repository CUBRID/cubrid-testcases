select
  vector_distance('[11, 2, 3]', '[2, 3, 4]', COSINE),
  '[11, 2, 3]' <c> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', DOT),
  inner_product('[1, 2, 3]', '[2, 3, 4]'),
  '[1, 2, 3]' <#> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', EUCLIDEAN),
  '[1, 2, 3]' <-> '[2, 3, 4]';

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', MANHATTAN),
  '[1, 2, 3]' <+> '[2, 3, 4]';
