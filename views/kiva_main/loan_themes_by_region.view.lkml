view: loan_themes_by_region {
  derived_table: {
      sql: select row_number() over(order by country) as prime_key, *
      from lukathesis.loan_themes_by_region ;;
  }

  dimension: prime_key {
    type: number
    primary_key: yes
    sql: ${TABLE}.prime_key ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: field_partner_name {
    type: string
    sql: ${TABLE}.Field_Partner_Name ;;
  }

  dimension: forkiva {
    type: yesno
    sql: ${TABLE}.forkiva ;;
  }

  dimension: geo {
    type: string
    sql: ${TABLE}.geo ;;
  }

  dimension: geocode {
    type: string
    sql: ${TABLE}.geocode ;;
  }

  dimension: geocode_old {
    type: string
    sql: ${TABLE}.geocode_old ;;
  }

  dimension: iso {
    type: string
    sql: ${TABLE}.ISO ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: loan_theme_id {
    type: string
    sql: ${TABLE}.Loan_Theme_ID ;;
  }

  dimension: loan_theme_type {
    type: string
    sql: ${TABLE}.Loan_Theme_Type ;;
  }

  dimension: location_name {
    type: string
    sql: ${TABLE}.LocationName ;;
  }

  dimension: lon {
    type: number
    sql: ${TABLE}.lon ;;
  }

  dimension: mpi_geo {
    type: string
    sql: ${TABLE}.mpi_geo ;;
  }

  dimension: mpi_region {
    type: string
    sql: ${TABLE}.mpi_region ;;
  }

  dimension: names {
    type: string
    sql: ${TABLE}.names ;;
  }

  dimension: number {
    type: number
    sql: ${TABLE}.number ;;
  }

  dimension: partner_id {
    type: number
    sql: ${TABLE}.Partner_ID ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: rural_pct {
    type: number
    sql: ${TABLE}.rural_pct ;;
  }

  dimension: sector {
    type: string
    sql: ${TABLE}.sector ;;
  }

  measure: avg_rural_pct {
    type: average
    description: "There are some region/location dimensions in this table
        that are fairly Repeated, so am averageing out their values to get a better descriptor"
    sql: ${rural_pct} ;;
  }

  measure: count {
    type: count
    drill_fields: [location_name, field_partner_name]
  }
}
