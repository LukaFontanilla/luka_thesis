view: use_word_analysis {
    derived_table: {
      sql: SELECT id, sector, use, use1 as use_test
              FROM
              (
                select id, sector, REGEXP_REPLACE(use, "[[:punct:]]", " ") as use
                from `lukathesis.kiva_loans_main`
              ) g
              LEFT JOIN UNNEST(SPLIT(use, ' ')) as use1
              WHERE
                ((use IS NOT NULL AND LENGTH(use) <> 0)) AND LENGTH(use1) > 2
              GROUP BY 1,2,3,4
              ORDER BY 1
               ;;
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
