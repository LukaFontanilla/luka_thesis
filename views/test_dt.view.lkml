# If necessary, uncomment the line below to include explore_source.
# include: "luka_thesis.model.lkml"

view: test_dt {
 derived_table: {
   sql:
       select *
       from
        (
         select RANK() OVER(PARTITION BY country ORDER BY count desc) as rank, *
         from
          (
           select country, sector, count(*) as count
           from `lookerdata.lukathesis.kiva_loans_main`
           group by 1,2
          )
        )
        where {% condition test_filter %} rank {% endcondition %}
          ;;
 }

  filter: test_filter {
    type: number
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: sector {
    type: string
    sql: ${TABLE}.sector ;;
  }

  dimension: count {
    type: number
  }
}
