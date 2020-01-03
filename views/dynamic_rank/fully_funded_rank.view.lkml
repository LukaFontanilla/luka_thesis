view: fully_funded_rank {
  derived_table: {
    persist_for: "360 hours"
    explore_source: kiva_loans_main {
      column: country {}
      column: sector {}
      column: count_yes {}
      column: percentage_fully_funded {}
      column: count {}
    }
  }
  dimension: country {}
  dimension: sector {}
  dimension: count_yes {
    type: number
  }
  dimension: percentage_fully_funded {
    value_format: "##.00%"
    type: number
  }
  dimension: count {
    type: number
  }
}
