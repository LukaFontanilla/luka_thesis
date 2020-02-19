view: uwanlp {
  sql_table_name: `lookerdata.lukathesis.uwanlp`
    ;;

  dimension: count {
    hidden: yes
    type: number
    sql: ${TABLE}.Count ;;
  }

  dimension: noun_classification {
    type: string
    sql: ${TABLE}.Noun_Classification ;;
  }

  dimension: use_test {
    type: string
    primary_key: yes
    sql: ${TABLE}.Use_Test ;;
  }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
}
