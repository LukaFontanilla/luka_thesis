view: loan_themes_ids {
  sql_table_name: lukathesis.loan_themes_ids ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: loan_theme_id {
    type: string
    sql: ${TABLE}.Loan_Theme_ID ;;
  }

  dimension: loan_theme_type {
    type: string
    sql: ${TABLE}.Loan_Theme_Type ;;
  }

  dimension: partner_id {
    type: number
    sql: ${TABLE}.Partner_ID ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
