connection: "lookerdata_standard_sql"

# include all the views
include: "/views/**/*.view"

datagroup: luka_thesis_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: luka_thesis_default_datagroup

explore: kiva_loans_main {}

explore: kiva_mpi_region_locations {}

explore: loan_themes_by_region {}

explore: loan_themes_ids {}
