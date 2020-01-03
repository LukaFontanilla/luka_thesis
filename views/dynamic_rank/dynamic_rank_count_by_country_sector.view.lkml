# Dynamic Rank: total count by country and sector

view: dynamic_rank_count_by_country_sector {
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
