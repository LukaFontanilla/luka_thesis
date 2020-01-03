view: fully_funded_rank_by_sector {
  derived_table: {
    persist_for: "360 hours"
    explore_source: kiva_loans_main {
      column: sector {}
      column: count_yes {}
      column: count {}
      column: percentage_fully_funded {}
    }
  }
  dimension: sector {}
  dimension: count_yes {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: percentage_fully_funded {
    value_format: "##.00%"
    type: number
  }
}
