view: kiva_mpi_region_locations {
  sql_table_name: lukathesis.kiva_mpi_region_locations ;;

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: geo {
    type: string
    sql: ${TABLE}.geo ;;
  }

  dimension: iso {
    type: string
    sql: ${TABLE}.ISO ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: location_name {
    type: string
    sql: ${TABLE}.LocationName ;;
  }

  dimension: lon {
    type: number
    sql: ${TABLE}.lon ;;
  }

  dimension: mpi {
    type: number
    sql: ${TABLE}.MPI ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: world_region {
    type: string
    sql: ${TABLE}.world_region ;;
  }

  measure: count {
    type: count
    drill_fields: [location_name]
  }
}
