include: "./kiva_loans_main.view"
view: +kiva_loans_main {
  dimension: test_id2 {
    type: number
    sql: ${id} * 9 ;;
  }
 }
