# Dynamic ranking table, this is the final table joined into the kiva loans main explore
# because the window function isn't uniform to each NDT I had to write multiple queries in the
# subselect

view: test_dt {
 derived_table: {
     sql: select country, sector, rank
          from
            (
             {% if rank_type._parameter_value == "dynamic_rank_count_by_country" %}
              select RANK() OVER(ORDER BY count desc) as rank, *
                from ${dynamic_rank_count_by_country.SQL_TABLE_NAME}

             {% elsif rank_type._parameter_value == "dynamic_rank_count_by_country_sector" %}
              select RANK() OVER(PARTITION BY country ORDER BY count desc) as rank, *
                from ${dynamic_rank_count_by_country_sector.SQL_TABLE_NAME}

             {% elsif rank_type._parameter_value == "fully_funded_rank" %}
              select RANK() OVER(ORDER BY percentage_fully_funded desc) as rank, *
                from ${fully_funded_rank.SQL_TABLE_NAME}

             {% elsif rank_type._parameter_value == "fully_funded_rank_by_sector" %}
              select RANK() OVER(ORDER BY percentage_fully_funded desc) as rank, * --sector, percentage_fully_funded
                from ${fully_funded_rank_by_sector.SQL_TABLE_NAME}

             {% elsif rank_type._parameter_value == "fully_funded_rank_by_country_sector" %}
              select RANK() OVER(PARTITION BY country ORDER BY percentage_fully_funded desc) as rank, *--country, sector, percentage_fully_funded
                from ${fully_funded_rank_by_country_sector.SQL_TABLE_NAME}

             {% else %}
              select RANK() OVER(ORDER BY count desc) as rank, *
                from ${dynamic_rank_count_by_country.SQL_TABLE_NAME}

             {% endif %}
            )
          where {% condition test_filter %} rank {% endcondition %}
          ;;
 }

  filter: test_filter {
    type: number
  }

  parameter: rank_type {
    type: unquoted
    allowed_value: {
      label: "Country Rank"
      value: "dynamic_rank_count_by_country"
    }
    allowed_value: {
      label: "Country Sector Rank"
      value: "dynamic_rank_count_by_country_sector"
    }
    allowed_value: {
      label: "Fully Funded Rank"
      value: "fully_funded_rank"
    }
    allowed_value: {
      label: "Fully Funded Rank by Sector"
      value: "fully_funded_rank_by_sector"
    }
    allowed_value: {
      label: "Fully Funded Rank by Country Sector"
      value: "fully_funded_rank_by_country_sector"
    }
  }


  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: sector {
    type: string
    sql: ${TABLE}.sector ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }
}
