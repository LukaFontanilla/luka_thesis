########################## Training/Testing Inputs ###########################
view: training_input {
  derived_table: {
    explore_source: kiva_loans_main {
      column: id {}
      column: country {}
      #column: region {}
      column: sector {}
      column: borrower_genders {}
      column: lender_count {}
      column: count {}
      filters: {
        field: kiva_loans_main.date_year
        value: "2017"
      }
    }
  }
}

view: testing_input {
  derived_table: {
    explore_source: kiva_loans_main {
      column: id {}
      column: country {}
      #column: region {}
      column: sector {}
      column: borrower_genders {}
      column: lender_count {}
      column: count {}
      filters: {
        field: kiva_loans_main.date_year
        value: "2016"
      }
    }
  }
}

######################## MODEL #############################

view: future_loan_count_model {
  derived_table: {
    persist_for: "168 hours"
    sql_create:
      CREATE OR REPLACE MODEL ${SQL_TABLE_NAME}
      OPTIONS(model_type='linear_reg'
        , input_label_cols=['count']
        , MAX_ITERATIONS=10
        , EARLY_STOP=FALSE
       -- , LS_INIT_LEARN_RATE=.45
        ) AS
      SELECT
         * EXCEPT(id)
      FROM ${training_input.SQL_TABLE_NAME};;
  }
}

######################## TRAINING INFORMATION #############################
explore:  future_loan_count_model_evaluation {}
explore: future_loan_count_model_training_info {}

# VIEWS:
view: future_loan_count_model_evaluation {
  derived_table: {
    sql: SELECT * FROM ml.EVALUATE(
          MODEL ${future_loan_count_model.SQL_TABLE_NAME},
          (SELECT * FROM ${testing_input.SQL_TABLE_NAME}));;
  }
  dimension: mean_absolute_error {type: number}
  dimension: mean_squared_error {type: number}
  dimension: mean_squared_log_error {type: number}
  dimension: median_absolute_error {type: number}

  ##########
  dimension: r2_score {type: number}
  # The R2 score is a statistical measure that determines if the linear regression predictions approximate the actual data.
  # 0 indicates that the model explains none of the variability of the response data around the mean.
  # 1 indicates that the model explains all the variability of the response data around the mean.
  ##########
  dimension: explained_variance {type: number}
}

view: future_loan_count_model_training_info {
  derived_table: {
    sql: SELECT  * FROM ml.TRAINING_INFO(MODEL ${future_loan_count_model.SQL_TABLE_NAME});;
  }
  dimension: training_run {type: number}
  dimension: iteration {type: number}
  dimension: loss_raw {sql: ${TABLE}.loss;; type: number hidden:yes}
  dimension: eval_loss {type: number}
  dimension: duration_ms {label:"Duration (ms)" type: number}
  dimension: learning_rate {type: number}
  measure: total_iterations {
    type: count
  }
  measure: loss {
    value_format_name: decimal_2
    type: sum
    sql:  ${loss_raw} ;;
  }
  measure: total_training_time {
    type: sum
    label:"Total Training Time (sec)"
    sql: ${duration_ms}/1000 ;;
    value_format_name: decimal_1
  }
  measure: average_iteration_time {
    type: average
    label:"Average Iteration Time (sec)"
    sql: ${duration_ms}/1000 ;;
    value_format_name: decimal_1
  }
}

############################# Prediction Timeeee #################################
view: future_input {
  derived_table: {
    explore_source: kiva_loans_main {
      column: id {}
      column: country {}
      #column: region {}
      column: sector {}
      column: borrower_genders {}
      column: lender_count {}
      # column: count {} : commenting out as the variable for the prediction
      filters: {
        field: kiva_loans_main.date_year
        value: "2017"
      }
    }
  }
}

view: future_purchase_prediction {
  derived_table: {
    sql: SELECT * FROM ml.PREDICT(
          MODEL ${future_loan_count_model.SQL_TABLE_NAME},
          (SELECT * FROM ${future_input.SQL_TABLE_NAME}));;
  }
  dimension: predicted_loan_count_in_future {type: number}
  dimension: country {type: string hidden: yes}
  dimension: sector {type: string hidden: yes}
}
