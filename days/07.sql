-- https://adventofcode.com/2021/day/7

with input as (
  select str_split(input, ',') as positions
    from {{ read_csv() }}
)

, unnested as (
  select unnest(positions)::int as position
    from input
)

, part_1 as (
  select sum(abs(position - (select median(position) from unnested)))::int as answer
    from unnested
)

, part_2_possible_positions as (
  select unnest(range((select max(position) from unnested) + 1)) as position
)

, part_2_costs as (
  select p.position as possible_position
       , c.position as crab_position
       , list_aggregate(range(abs(possible_position - crab_position) + 1), 'sum') as cost
    from part_2_possible_positions p
   cross join unnested c
)

, part_2_computed_costs as (
  select possible_position
       , sum(cost) as cost
    from part_2_costs
   group by 1
)

, part_2 as (
  select min(cost) as answer
    from part_2_computed_costs
)

select 1 as part
     , answer
  from part_1
 union all
select 2 as part
     , answer
  from part_2
