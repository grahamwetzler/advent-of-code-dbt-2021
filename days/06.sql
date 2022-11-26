-- https://adventofcode.com/2021/day/6

with recursive input as (
  select unnest(str_split(input, ',')) as fish_age
  from {{ read_csv() }}
)

, fish_counts as (
  select fish_age
       , count(*) as fish_count
    from input
   group by 1
)

, starting as (
  select fish_age
       , coalesce(fish_count, 0) as fish_count
    from (select unnest(range(9)) as fish_age)
    left join fish_counts
   using (fish_age)
   order by fish_age
)

, breed(day, fish_counts) as (
  select 0 as day
       , list(fish_count) as fish_counts
    from starting
  group by 1
   union all
  select day + 1 as day
       , [
          fish_counts[2],
          fish_counts[3],
          fish_counts[4],
          fish_counts[5],
          fish_counts[6],
          fish_counts[7],
          fish_counts[8] + fish_counts[1],
          fish_counts[9],
          fish_counts[1]
        ] as fish_counts
    from breed
   where day <= 256
)

, part_1 as (
  select list_aggregate(fish_counts, 'sum') as answer
    from breed
   where day = 80
)

, part_2 as (
  select list_aggregate(fish_counts, 'sum') as answer
    from breed
   where day = 256
)

select 1 as part
     , answer
  from part_1
 union all
select 2 as part
     , answer
  from part_2
