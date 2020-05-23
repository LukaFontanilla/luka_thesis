view: mpi_aggregate {
  derived_table: {
    sql: SELECT * EXCEPT(ISO_country_code)
      FROM `lookerdata.lukathesis.mpi_national` as n
      LEFT JOIN (
                 SELECT * EXCEPT(Country) FROM `lookerdata.lukathesis.mpi_subnational`
                ) sn
        ON n.ISO = sn.ISO_country_code
      WHERE {% if country._is_filtered %}
              {% condition %} country {% endcondition %}
            {% elsif sub_national_region._is_filtered %}
              {% condition %} sub_national_region {% endcondition %}
            {% else %}
              1=1
            {% endif %}
      LIMIT 10
       ;;
    datagroup_trigger: luka_thesis_default_datagroup
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: iso {
    type: string
    sql: ${TABLE}.ISO ;;
    map_layer_name: countries
  }

  dimension: country {
    type: string
    sql: ${TABLE}.Country ;;
  }

  dimension: mpi_urban {
    type: number
    sql: ${TABLE}.MPI_Urban ;;
  }

  dimension: headcount_ratio_urban {
    type: number
    sql: ${TABLE}.Headcount_Ratio_Urban ;;
  }

  dimension: intensity_of_deprivation_urban {
    type: number
    sql: ${TABLE}.Intensity_of_Deprivation_Urban ;;
  }

  dimension: mpi_rural {
    type: number
    sql: ${TABLE}.MPI_Rural ;;
  }

  dimension: headcount_ratio_rural {
    type: number
    sql: ${TABLE}.Headcount_Ratio_Rural ;;
  }

  dimension: intensity_of_deprivation_rural {
    type: number
    sql: ${TABLE}.Intensity_of_Deprivation_Rural ;;
  }

  dimension: sub_national_region {
    type: string
    sql: ${TABLE}.Sub_national_region ;;
  }

  dimension: world_region {
    type: string
    sql: ${TABLE}.World_region ;;
  }

  dimension: mpi_national {
    type: number
    sql: ${TABLE}.MPI_National ;;
  }

  dimension: mpi_regional {
    type: number
    sql: ${TABLE}.MPI_Regional ;;
  }

  dimension: headcount_ratio_regional {
    type: number
    sql: ${TABLE}.Headcount_Ratio_Regional ;;
  }

  dimension: intensity_of_deprivation_regional {
    type: number
    sql: ${TABLE}.Intensity_of_deprivation_Regional ;;
  }

  set: detail {
    fields: [
      iso,
      country,
      mpi_urban,
      headcount_ratio_urban,
      intensity_of_deprivation_urban,
      mpi_rural,
      headcount_ratio_rural,
      intensity_of_deprivation_rural,
      sub_national_region,
      world_region,
      mpi_national,
      mpi_regional,
      headcount_ratio_regional,
      intensity_of_deprivation_regional
    ]
  }
}
