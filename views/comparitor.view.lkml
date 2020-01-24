# used strictly for comparitor analysis
view: num {
  derived_table : {
    sql: SELECT 1 as n UNION ALL SELECT 2 ;;
  }

  dimension: n {
    hidden: yes
  }
}
