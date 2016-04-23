$(document).on("page:change", function() {
  $("#post-by-day").highcharts({
    chart: {
      type: "line"
    },
    title: {
      text: I18n.t("statistic.charts.question_number.title")
    },
    xAxis: {
      categories: $("#post-by-day").data("x-axis")
    },
    yAxis: {
      title: {
        text: I18n.t("statistic.title.number_post")
      }
    },
    series: [{
      name: I18n.t("statistic.charts.question_number.title"),
      data: $("#post-by-day").data("y-axis")
    }]
  });

  if ($("#donut-chart").length > 0) {
   chart = new Highcharts.Chart({
      chart: {
        renderTo: "donut-chart",
        type: "pie",
        options3d: {
          enabled: true,
          alpha: 45
        }
      },
      title: {
        text: I18n.t("statistic.title.post_replied")
      },
      plotOptions: {
        pie: {
          innerSize: 100,
          depth: 45
        }
      },
      series: [{
        name: I18n.t("statistic.title.number_post"),
        data: [
          [$("#donut-chart").data("donut-chart-name")[0], $("#donut-chart").data("donut-chart-values")[0]],
          [$("#donut-chart").data("donut-chart-name")[1], $("#donut-chart").data("donut-chart-values")[1]]
        ]
      }]
    });
  }
});
// for (key in donut_chart_data_name) {
//       chart.addSeries({
//         name: "abc",
//         data: [donut_chart_data_name[key], donut_chart_data_values[key]],
//       });
//     }
