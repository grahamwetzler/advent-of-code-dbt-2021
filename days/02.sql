-- https://adventofcode.com/2021/day/2

with input as (
  select str_split(input, ' ') as direction_array
    from {{ read_csv() }}
)

, parsed as (
  select direction_array[1] as command
       , direction_array[2]::int as units
       , row_number() over () as sequence
    from input
)

, formatted as (
  select case
          when command in ('up', 'down') then 'horizonal'
          else 'vertical'
         end as direction
       , case
          when command = 'up' then units * -1
          else units
         end as units
    from parsed
)

, part_1 as (
  select direction
       , sum(units) as units
    from formatted
   group by 1
)

, part_2 as (
  select command
       , case
          when command = 'down' then units
          when command = 'up' then units * -1
          else 0
         end as aim
       , case
          when command = 'forward' then units
          else 0
         end as horizontal_position
       , sum(aim) over (order by sequence) as current_aim
       , sum(horizontal_position) over (order by sequence) as current_horizontal_position
       , case
          when command = 'forward' then current_aim * horizontal_position
          else 0
         end as depth
    from parsed
)


select 1 as part
     , product(units)::int as answer
  from part_1
 union all
select 2 as part
     , sum(depth) * max(current_horizontal_position) as answer
  from part_2
