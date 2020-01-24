########################## Training/Testing Inputs ###########################
view: training_input {
  derived_table: {
    explore_source: kiva_loans_main {
      #column: id {}
      column: country{}
      column: region {}
      #column: activity {}
      column: sector {}
      column: borrower_genders {}
      column: mpi { field: kiva_mpi_region_locations.mpi }
      column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
      column: date_year {}
      column: lender_count {}
      #column: loan_amount {}
      column: count {}
      filters: {
        field: kiva_loans_main.date_year
        value: "2016"
      }
      filters: {
        field: kiva_loans_main.count
        value: "NOT NULL"
      }
    }
  }
}

view: predictions_model {
  derived_table: {
    persist_for: "168 hours"
    sql_create:
      CREATE OR REPLACE MODEL ${SQL_TABLE_NAME}
      OPTIONS (
        model_type='linear_reg',
        input_label_cols=['count'],
        max_iterations=10,
        early_stop=FALSE
        --l1_reg=0.025,
        --l2_reg=0.025
        )
      AS (
        SELECT *
        FROM ${training_input.SQL_TABLE_NAME}
      );;
  }
}

#################### Evaluation #####################
view: test_input {
  derived_table: {
    explore_source: kiva_loans_main {
      #column: id {}
      column: country {}
      column: region {}
      #column: activity {}
      column: sector {}
      column: borrower_genders {}
      column: mpi { field: kiva_mpi_region_locations.mpi }
      column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
      column: date_year {}
      column: lender_count {}
      #column: loan_amount {}
      column: count {}
      filters: {
        field: kiva_loans_main.date_year
        value: "2017"
      }
      filters: {
        field: kiva_loans_main.count
        value: "NOT NULL"
      }
    }
  }
}

explore: model_evaluation {}
view: model_evaluation {
  derived_table: {
    sql: SELECT * FROM ml.EVALUATE(
      MODEL ${predictions_model.SQL_TABLE_NAME},
      (SELECT * FROM ${test_input.SQL_TABLE_NAME}
      )
    );;
  }
  dimension: mean_absolute_error {type:number}
  dimension: mean_squared_error {type:number}
  dimension: mean_squared_log_error {type:number}
  dimension: median_absolute_error {type:number}
  dimension: r2_score {type:number}
  dimension: explained_variance {type:number}
}


#################### Training #####################
explore: model_training_info {}
view: model_training_info {
  derived_table: {
    sql: SELECT * FROM ml.TRAINING_INFO(MODEL ${predictions_model.SQL_TABLE_NAME});;
  }
  dimension: training_run {type: number}
  dimension: iteration {type: number}
  dimension: eval_loss {type: number}
  dimension: duration_ms {label:"Duration (ms)" type: number}
  dimension: learning_rate {type: number}
  measure: total_iterations {type: count}
  measure: loss {type: sum value_format_name: decimal_2 sql: ${TABLE}.loss;; }
  measure: total_training_time {type: sum value_format_name: decimal_1
    label:"Total Training Time (sec)"
    sql: ${duration_ms}/1000 ;;
  }
  measure: average_iteration_time {
    type: average
    label:"Average Iteration Time (sec)"
    sql: ${duration_ms}/1000 ;;
    value_format_name: decimal_1
  }
}

################### Weights #######################
# explore: model_weights {}
# view: model_weights {
#   derived_table: {
#     sql: SELECT * FROM ML.WEIGHTS(MODEL ${predictions_model.SQL_TABLE_NAME},
#         STRUCT(true AS standardize)) ;;
#   }
#   dimension: processed_input {}
#   dimension: weight {type: number}
#   #dimension: category_weights.category {type:string}
#   dimension: category_weights.weight {type:number}
# }



################### END ######################

#################### Predictions #####################
explore: future_prediction {}
view: future_input {
  derived_table: {
    explore_source: kiva_loans_main {
      column: id {}
      column: country {}
      column: region {}
      #column: activity {}
      column: sector {}
      column: borrower_genders {}
      column: mpi { field: kiva_mpi_region_locations.mpi }
      column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
      column: date_year {}
      column: lender_count {}
      #column: loan_amount {}
      column: count {}
      filters: {
        field: kiva_loans_main.date_year
        value: "2017"
      }
      filters: {
        field: kiva_loans_main.count
        value: "NOT NULL"
      }
    }
  }
}

view: future_prediction {
  derived_table: {
    persist_for: "168 hours"
    sql:
      SELECT * FROM ML.PREDICT(
        MODEL ${predictions_model.SQL_TABLE_NAME},
        ( SELECT *
          FROM ${future_input.SQL_TABLE_NAME}
        )
      );;
  }
  dimension: id {hidden:yes}
  dimension: country {}
  dimension: sector {}
  dimension: actual_count {type:number sql:${TABLE}.count;;}
  dimension: predicted_count {type:number sql:${TABLE}.predicted_count;;}
  measure: ac {type:sum sql:${actual_count};;}
  measure: pc {type:sum sql:${predicted_count};;}
  measure: residual {
    type: number
    sql: ${ac} - ${pc} ;;
  }
  # measure: best_fit {
  #   type: number
  #   description: "the closer this number is to zero, the more likely that the line is of best fit"
  #   sql: sum(${residual}) ;;
  # }
}
