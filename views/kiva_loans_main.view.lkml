view: kiva_loans_main {
  sql_table_name: lukathesis.kiva_loans_main ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: activity {
    type: string
    sql: ${TABLE}.activity ;;
  }

  dimension: borrower_genders {
    type: string
    sql: ${TABLE}.borrower_genders ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_code {
    type: string
    sql: ${TABLE}.country_code ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: disbursed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.disbursed_time ;;
  }

  dimension: funded_amount {
    type: number
    sql: ${TABLE}.funded_amount ;;
  }

  dimension_group: funded {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.funded_time ;;
  }

  dimension: lender_count {
    type: number
    sql: ${TABLE}.lender_count ;;
  }

  dimension: loan_amount {
    type: number
    sql: ${TABLE}.loan_amount ;;
  }

  dimension: partner_id {
    type: number
    sql: ${TABLE}.partner_id ;;
  }

  dimension_group: posted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.posted_time ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: repayment_interval {
    type: string
    sql: ${TABLE}.repayment_interval ;;
  }

  dimension: sector {
    type: string
    sql: ${TABLE}.sector ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}.tags ;;
  }

  dimension: term_in_months {
    type: number
    sql: ${TABLE}.term_in_months ;;
  }

  dimension: use {
    type: string
    sql: ${TABLE}.use ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
