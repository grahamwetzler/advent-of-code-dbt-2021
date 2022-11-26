with input as (
  select input::int as depth
    from {{ read_csv() }}
)

, depths_part_1 as (
  select depth
       , lag(depth) over () as previous_depth
    from input
)

, part_1 as (
  select *
    from depths_part_1
   where depth > previous_depth
)

, depths_part_2 as (
  select depth
       , sum(depth) over (rows between 2 preceding
                           and current row) as window_sum_depth
    from input
)

, part_2 as (
  select *
    from depths_part_2
 qualify window_sum_depth > lag(window_sum_depth) over ()
  offset 2
)

select 1 as part
     , count(*) as answer
  from part_1
 union all
select 2 as part
     , count(*) as answer
  from part_2
