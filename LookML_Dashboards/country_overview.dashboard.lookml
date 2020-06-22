- dashboard: countries_overview
  title: Countries Overview
  layout: newspaper
  elements:
  - name: 'Countries Overview: Home'
    type: text
    title_text: 'Countries Overview: Home'
    body_text: This is the Countries Overview Home. Here you will find details regarding
      the top 10 countries by each category.
    row: 5
    col: 0
    width: 7
    height: 8
  - title: Top 10 Loan Count by Country
    name: Top 10 Loan Count by Country
    model: luka_thesis
    explore: kiva_loans_main
    type: looker_bar
    fields: [kiva_loans_main.country, kiva_loans_main.count]
    sorts: [kiva_loans_main.count desc]
    limit: 10
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: b40c75b1-e794-482f-8fb6-9373a0052342
      palette_id: 2749853e-4c47-4781-a9ad-998f9c9fb1c7
      options:
        steps: 5
    y_axes: [{label: '', orientation: bottom, series: [{axisId: kiva_loans_main.count,
            id: kiva_loans_main.count, name: Kiva Loans Main}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors: {}
    column_spacing_ratio: 0
    column_group_spacing_ratio: 0.2
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    defaults_version: 1
    listen:
      Date Year: kiva_loans_main.date_year
      Country: kiva_loans_main.country
    row: 13
    col: 7
    width: 9
    height: 6
  - title: World Loan Data
    name: World Loan Data
    model: luka_thesis
    explore: kiva_loans_main
    type: looker_map
    fields: [kiva_mpi_region_locations.country, kiva_mpi_region_locations.count]
    filters: {}
    sorts: [kiva_mpi_region_locations.count desc]
    limit: 500
    map_plot_mode: points
    heatmap_gridlines: true
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.8
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_scale_indicator: metric
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_latitude: 7.514980942395884
    map_longitude: 22.788391113281254
    map_zoom: 2
    defaults_version: 1
    listen:
      Date Year: kiva_loans_main.date_year
      Country: kiva_loans_main.country
    row: 5
    col: 7
    width: 17
    height: 8
  - name: Top 10 Analyses
    type: text
    title_text: Top 10 Analyses
    body_text: |-
      - Top 10 Loan Count
      - Top 10 Loan Count by Sector
    row: 13
    col: 0
    width: 7
    height: 6
  - name: Overview Metrics
    type: text
    title_text: Overview Metrics
    row: 0
    col: 0
    width: 24
    height: 2
  - title: Total loans
    name: Total loans
    model: luka_thesis
    explore: kiva_loans_main
    type: single_value
    fields: [kiva_loans_main.date_year, kiva_loans_main.count]
    fill_fields: [kiva_loans_main.date_year]
    sorts: [kiva_loans_main.date_year desc]
    limit: 500
    dynamic_fields: [{table_calculation: percentage_of_previous, label: Percentage
          of Previous, expression: 'offset(${kiva_loans_main.count}, 1)', value_format: !!null '',
        value_format_name: id, _kind_hint: measure, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#66BB6A"
    series_types: {}
    defaults_version: 1
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_fields: [kiva_loans_main.date_year]
    listen:
      Date Year: kiva_loans_main.date_year
      Country: kiva_loans_main.country
    row: 2
    col: 0
    width: 8
    height: 3
  - title: Total Fully Funded
    name: Total Fully Funded
    model: luka_thesis
    explore: kiva_loans_main
    type: single_value
    fields: [kiva_loans_main.date_year, kiva_loans_main.count_yes, kiva_loans_main.percentage_fully_funded]
    fill_fields: [kiva_loans_main.date_year]
    sorts: [kiva_loans_main.date_year desc]
    limit: 500
    dynamic_fields: [{table_calculation: percentage_of_previous, label: Percentage
          of Previous, expression: "(${kiva_loans_main.count_yes} - offset(${kiva_loans_main.count_yes},1))/offset(${kiva_loans_main.count_yes},1)",
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    listen:
      Date Year: kiva_loans_main.date_year
      Country: kiva_loans_main.country
    row: 2
    col: 8
    width: 8
    height: 3
  - title: Total Funded Amount
    name: Total Funded Amount
    model: luka_thesis
    explore: kiva_loans_main
    type: single_value
    fields: [kiva_loans_main.total_funded_amount, kiva_loans_main.date_year]
    fill_fields: [kiva_loans_main.date_year]
    sorts: [kiva_loans_main.date_year desc]
    limit: 500
    dynamic_fields: [{table_calculation: percentage_of_previous, label: Percentage
          of Previous, expression: "(${kiva_loans_main.total_funded_amount} - offset(${kiva_loans_main.total_funded_amount},1))/offset(${kiva_loans_main.total_funded_amount},1)",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    custom_color: "#2B99F7"
    value_format: "$#,###"
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#FFCA28",
        font_color: !!null '', color_application: {collection_id: b40c75b1-e794-482f-8fb6-9373a0052342,
          palette_id: fd886420-6da6-4a87-b6c7-1550f762e4cb}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    listen:
      Date Year: kiva_loans_main.date_year
      Country: kiva_loans_main.country
    row: 2
    col: 16
    width: 8
    height: 3
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: luka_thesis
    explore: kiva_loans_main
    listens_to_filters: []
    field: kiva_loans_main.country
  - name: Date Year
    title: Date Year
    type: field_filter
    default_value: '2017'
    allow_multiple_values: true
    required: false
    model: luka_thesis
    explore: kiva_loans_main
    listens_to_filters: []
    field: kiva_loans_main.date_year
