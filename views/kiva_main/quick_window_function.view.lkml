view: quick_window_function {
    derived_table: {
      sql: select country, sector, row_number() over(partition by country order by count(*) desc) as rank
           from lukathesis.kiva_loans_main
           where {% condition country_param %} country {% endcondition %}
           group by country, sector;;
      datagroup_trigger: luka_thesis_default_datagroup
      }


    dimension: country {}
    dimension: sector {}
    dimension: sector1 {
      type: string
      sql: (select sector from ${quick_window_function.SQL_TABLE_NAME}
            where rank = 1)
          ;;
    }

  dimension: sector2 {
    type: string
    sql: (select sector from ${quick_window_function.SQL_TABLE_NAME}
            where rank = 2)
          ;;
  }

  dimension: sector3 {
    type: string
    sql: (select sector from ${quick_window_function.SQL_TABLE_NAME}
            where rank = 3)
          ;;
  }

  filter: country_param {
    type: string
    suggest_dimension: country
  }

    dimension: rank {
      type: number
      sql: ${TABLE}.rank;;
  }

#   measure: count_rank_1 {
#     type: number
#     sql: count(${sector1}) ;;
#   }
}
