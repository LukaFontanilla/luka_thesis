# Dyanmic Rank: County by country

view: dynamic_rank_count_by_country {
  derived_table: {
    persist_for: "360 hours"
    explore_source: kiva_loans_main {
      column: country {}
      column: sector {}
      column: count {}
    }
  }
  dimension: country {}
  dimension: sector {}
  dimension: count {
    type: number
  }
}
