view: use_word_analysis {
    derived_table: {
      sql: SELECT id
                  , sector
                  , country
                  , use
                  , regexp_replace(use1, '"', '') as use_test
           FROM
              (
                select id
                      , sector
                      , country
                      , REGEXP_REPLACE(use, "[[:punct:]]", " ") as use
                from `lukathesis.kiva_loans_main`
              ) g
           LEFT JOIN UNNEST(SPLIT(use, ' ')) as use1
           WHERE
                ((use IS NOT NULL AND LENGTH(use) <> 0)) AND LENGTH(use1) > 2
              AND
                use1 NOT IN ('and', 'for', 'her', 'his', 'other', 'like', 'etc', 'new', 'the')
              AND
                {% if country_filter._in_query %}
                  {% condition country_filter %} country {% endcondition %}
                {% elsif sector_filter._in_query %}
                  {% condition sector_filter %} sector {% endcondition %}
                {% else %}
                  1=1
                {% endif %}
           GROUP BY 1,2,3,4,5
           ORDER BY 1
               ;;
    datagroup_trigger: luka_thesis_default_datagroup
    }

    filter: country_filter {
      type: string
      suggest_dimension: country
    }

    filter: sector_filter {
      type: string
      suggest_dimension: sector
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: id {
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension: sector {
      type: string
      sql: ${TABLE}.sector ;;
    }

    dimension: country {
      type: string
      sql: ${TABLE}.country ;;
    }

    dimension: use {
      type: string
      sql: ${TABLE}.use ;;
    }

    dimension: use_test {
      type: string
      sql: ${TABLE}.use_test ;;
    }

    set: detail {
      fields: [id, sector, use, use_test]
    }
  }
