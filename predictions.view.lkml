########################## Training/Testing Inputs ###########################
view: training_input {
  derived_table: {
    explore_source: kiva_loans_main {
      column: id {}
      column: country {}
      column: region {}
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
      column: region {}
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
      OPTIONS(model_type='logistic_reg'
        , labels=['will_get_loan_in_future']
        ) AS
      SELECT
         * EXCEPT(id)
      FROM ${training_input.SQL_TABLE_NAME};;
  }
}

######################## TRAINING INFORMATION #############################
explore:  future_loan_count_model_evaluation {}
explore: future_loan_count_model_training_info {}
explore: roc_curve {}

# VIEWS:
view: future_loan_count_model_evaluation {
  derived_table: {
    sql: SELECT * FROM ml.EVALUATE(
          MODEL ${future_loan_count_model.SQL_TABLE_NAME},
          (SELECT * FROM ${testing_input.SQL_TABLE_NAME}));;
  }
  dimension: recall {type: number value_format_name:percent_2}
  dimension: accuracy {type: number value_format_name:percent_2}
  dimension: f1_score {type: number value_format_name:percent_3}
  dimension: log_loss {type: number}
  dimension: roc_auc {type: number}
}

view: roc_curve {
  derived_table: {
    sql: SELECT * FROM ml.ROC_CURVE(
        MODEL ${future_loan_count_model.SQL_TABLE_NAME},
        (SELECT * FROM ${testing_input.SQL_TABLE_NAME}));;
  }
  dimension: threshold {
    type: number
    # link: {
    #   label: "Likely Customers to Purchase"
    #   url: "/explore/bqml_ga_demo/ga_sessions?fields=ga_sessions.fullVisitorId,future_purchase_prediction.max_predicted_score&f[future_purchase_prediction.predicted_will_purchase_in_future]=%3E%3D{{value}}"
    #   icon_url: "http://www.looker.com/favicon.ico"
    # }
  }
  dimension: recall {type: number value_format_name: percent_2}
  dimension: false_positive_rate {type: number}
  dimension: true_positives {type: number }
  dimension: false_positives {type: number}
  dimension: true_negatives {type: number}
  dimension: false_negatives {type: number }
  dimension: precision {
    type:  number
    value_format_name: percent_2
    sql:  ${true_positives} / NULLIF((${true_positives} + ${false_positives}),0);;
  }
  measure: total_false_positives {
    type: sum
    sql: ${false_positives} ;;
  }
  measure: total_true_positives {
    type: sum
    sql: ${true_positives} ;;
  }
  dimension: threshold_accuracy {
    type: number
    value_format_name: percent_2
    sql:  1.0*(${true_positives} + ${true_negatives}) / NULLIF((${true_positives} + ${true_negatives} + ${false_positives} + ${false_negatives}),0);;
  }
  dimension: threshold_f1 {
    type: number
    value_format_name: percent_3
    sql: 2.0*${recall}*${precision} / NULLIF((${recall}+${precision}),0);;
  }
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
      column: region {}
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
  measure: max_predicted_score {
    type: max
    value_format_name: percent_2
    sql: ${predicted_loan_count_in_future} ;;
  }
  measure: average_predicted_score {
    type: average
    value_format_name: percent_2
    sql: ${predicted_loan_count_in_future} ;;
  }
}
