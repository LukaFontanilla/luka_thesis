include: "./kiva_loans_main.view"

view: +kiva_loans_main {
  dimension: test_id {
    type: number
    sql: ${id} * 10 ;;
  }
 }
