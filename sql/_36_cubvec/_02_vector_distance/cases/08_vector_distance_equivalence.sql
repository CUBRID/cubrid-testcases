select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', COSINE),
  cosine_distance('[1, 2, 3]', '[2, 3, 4]');

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', DOT),
  inner_product('[1, 2, 3]', '[2, 3, 4]');

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', EUCLIDEAN),
  l2_distance('[1, 2, 3]', '[2, 3, 4]');

select
  vector_distance('[1, 2, 3]', '[2, 3, 4]', MANHATTAN),
  l1_distance('[1, 2, 3]', '[2, 3, 4]');
