connection: "lookerdata_standard_sql" ## for dev instance
#connection: "bigquery_publicdata_standard_sql" ## for master instance

# include all the views
include: "/views/**/*.view"
include: "/BQML_analysis/*.view"
include: "/views/dynamic_rank/**/*.view"
include: "/views/kiva_main/**/*.view"


# aggregate_awareness: yes ####

datagroup: luka_thesis_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM `lukathesis.kiva_loans_main`;;
  max_cache_age: "24 hours"
}

#persist_with: luka_thesis_default_datagroup

explore: kiva_loans_main {
  # access_filter: {
  #   field: kiva_mpi_region_locations.iso
  #   user_attribute: country_luka
  # }

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
  query: average_mpi_by_region_over_time {
    dimensions: [kiva_mpi_region_locations.world_region]
    measures: [kiva_mpi_region_locations.mpi_average]
    sort: {field:kiva_mpi_region_locations.mpi_average desc:yes}
  }
}

explore: use_word_analysis {
  sql_always_where: ${uwanlp.noun_classification} = "Noun" ;;
  join: uwanlp {
    type: left_outer
    relationship: many_to_one
    sql_on: ${use_word_analysis.use_test} = ${uwanlp.use_test} ;;
  }
  # join: kiva_loans_main {
  #   type: left_outer
  #   relationship: many_to_one
  #   sql_on: 0=1 ;;
  # }
}

explore: dynamic_rank_count_by_country_sector {}
explore: mpi_aggregate {}
