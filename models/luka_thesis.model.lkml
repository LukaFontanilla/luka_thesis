#connection: "lookerdata_standard_sql" ## for dev instance
connection: "bigquery_publicdata_standard_sql" ## for master instance

# include all the views
include: "/views/**/*.view"
include: "/BQML_analysis/*.view"
include: "/views/dynamic_rank/**/*.view"
include: "/views/kiva_main/**/*.view"

aggregate_awareness: yes

datagroup: luka_thesis_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: luka_thesis_default_datagroup

explore: kiva_loans_main {
  #sql_always_where: ${kiva_loans_main.country} = {% parameter quick_window_function.country_param %} ;;
  join: num {
    type: cross
    relationship: one_to_many
  }
  join: loan_themes_ids {
    relationship: many_to_one
    type: left_outer
    sql_on: ${kiva_loans_main.id} = ${loan_themes_ids.id} ;;
  }
  join: loan_themes_by_region {
    relationship: one_to_many
    type: left_outer
    sql_on: ${loan_themes_ids.loan_theme_id} = ${loan_themes_by_region.loan_theme_id} ;;
  }
  join: kiva_mpi_region_locations {
    relationship: one_to_many
    type: left_outer
    sql_on: ${kiva_mpi_region_locations.region} = ${kiva_loans_main.region} ;;
  }
  join: test_dt {
    relationship: many_to_one
    type: inner
    sql_on: ${kiva_loans_main.country} = ${test_dt.country};;
  }
  join: quick_window_function {
    relationship: many_to_one
    type: left_outer
    sql_on: ${kiva_loans_main.country} = ${quick_window_function.country} ;;
  }

  ###---------Turtles------------###
  query: loans_by_created_year {
    dimensions: [date_year]
    measures: [count]
    sort: {field:date_year desc:no}
  }
  query: loans_by_country_top_10 {
    dimensions: [country]
    measures: [count]
    sort: {field:count desc:yes}
    limit: 10
  }
  query: loans_by_sector_top_5 {
    dimensions: [sector]
    measures: [count]
    sort: {field:count desc:yes}
    limit: 5
  }
  query: total_funded_amount_by_year {
    dimensions: [date_year]
    measures: [total_funded_amount]
    sort: {field:date_year desc:no}
    limit: 10
  }
}

explore: use_word_analysis {}
