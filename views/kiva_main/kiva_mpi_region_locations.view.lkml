view: kiva_mpi_region_locations {
  derived_table: {
    sql: select row_number() over(order by country) as prime_key, *
        from lukathesis.kiva_mpi_region_locations ;;
  }

  dimension: prime_key {
    type: number
    primary_key: yes
    sql: ${TABLE}.prime_key ;;
  }

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

  ##### location type #####

  dimension: location {
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lon} ;;
  }

  ##### end #####

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
