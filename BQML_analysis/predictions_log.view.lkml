view: training_input_2 {
    derived_table: {
      explore_source: kiva_loans_main {
        #column: id {}
        column: country {}
        column: region {}
        column: activity {}
        column: sector {}
        column: borrower_genders {}
        column: mpi { field: kiva_mpi_region_locations.mpi }
        column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
        column: lender_count {}
        column: fully_funded {}
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

  view: predictions_model_2 {
    derived_table: {
      persist_for: "168 hours"
      sql_create:
      CREATE OR REPLACE MODEL ${SQL_TABLE_NAME}
      OPTIONS (
        model_type='logistic_reg',
        input_label_cols=['fully_funded'],
        max_iterations=10,
        early_stop=FALSE
        --l1_reg=0.025,
        --l2_reg=0.025
        )
      AS (
        SELECT *
        FROM ${training_input_2.SQL_TABLE_NAME}
      );;
    }
  }

#################### Evaluation #####################
  view: test_input_2 {
    derived_table: {
      explore_source: kiva_loans_main {
        #column: id {}
        column: country {}
        column: region {}
        column: activity {}
        column: sector {}
        column: borrower_genders {}
        column: mpi { field: kiva_mpi_region_locations.mpi }
        column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
        column: lender_count {}
        column: fully_funded {}
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

  explore: model_evaluation_2 {}
  view: model_evaluation_2 {
    derived_table: {
      sql: SELECT * FROM ml.EVALUATE(
              MODEL ${predictions_model_2.SQL_TABLE_NAME},
              (SELECT * FROM ${test_input_2.SQL_TABLE_NAME}
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
explore:  future_purchase_model_evaluation {}
explore: future_purchase_model_training_info {}
explore: roc_curve {}

# VIEWS:
view: future_purchase_model_evaluation {
  derived_table: {
    sql: SELECT * FROM ml.EVALUATE(
          MODEL ${predictions_model_2.SQL_TABLE_NAME},
          (SELECT * FROM ${test_input_2.SQL_TABLE_NAME}));;
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
        MODEL ${predictions_model_2.SQL_TABLE_NAME},
        (SELECT * FROM ${test_input_2.SQL_TABLE_NAME}));;
  }
  dimension: threshold {
    type: number
    link: {
      label: ""
      url: ""
      icon_url: ""
    }
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

view: future_purchase_model_training_info {
  derived_table: {
    sql: SELECT  * FROM ml.TRAINING_INFO(MODEL ${predictions_model_2.SQL_TABLE_NAME});;
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

#################### Predictions #####################
  explore: future_prediction_2 {}
  view: future_input_2 {
    derived_table: {
      explore_source: kiva_loans_main {
        column: id {}
        column: country {}
        column: region {}
        column: activity {}
        column: sector {}
        column: borrower_genders {}
        column: mpi { field: kiva_mpi_region_locations.mpi }
        column: loan_theme_type { field: loan_themes_ids.loan_theme_type}
        column: lender_count {}
        column: fully_funded {}
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

  view: future_prediction_2 {
    derived_table: {
      persist_for: "168 hours"
      sql:
      SELECT * FROM ML.PREDICT(
        MODEL ${predictions_model_2.SQL_TABLE_NAME},
        ( SELECT *
          FROM ${future_input_2.SQL_TABLE_NAME}
        )
      );;
    }
    dimension: id {hidden:yes}
    dimension: country {}
    dimension: sector {}
    dimension: actual_fully_funded {type:number sql:${TABLE}.count;;}
    dimension: predicted_fully_funded {type:number sql:${TABLE}.predicted_fully_funded;;}
  }
