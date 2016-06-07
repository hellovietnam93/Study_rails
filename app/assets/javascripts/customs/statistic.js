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
    credits: {
      enabled: false
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
      credits: {
        enabled: false
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

  $.each($('*[id^="statistic-member-"]'), function (key, value){
    var memberId = $(value).data("member-id");
    var keys = $(value).data("statistic-keys");
    var values = $(value).data("satistic-values");
    if ($("#statistic-member-" + memberId).length > 0) {
      chart = new Highcharts.Chart({
        chart: {
          renderTo: "statistic-member-" + memberId,
          type: "line",
          polar: true,
          spacingTop: 3,
          spacingRight: 10,
          spacingBottom: 3,
          spacingLeft: 105
        },
        title: {
          text: I18n.t("statistic.title.student_chart"),
          x: -80,
          style: {
            fontWeight: "bold"
          }
        },
        pane: {
          size: "150%"
        },
        xAxis: {
          categories: keys,
          tickmarkPlacement: "on",
          lineWidth: 0
        },
        yAxis: {
          minTickInterval: 5,
          minorTickInterval: 1,
          gridLineInterpolation: "polygon",
          min: 0
        },
        credits: {
          enabled: false
        },
        legend: {
          align: "right",
          verticalAlign: "top",
          y: 70,
          layout: "vertical"
        },
        series: [{
          name: I18n.t("statistic.title.student_info"),
          data: values,
          pointPlacement: 'on'
        }]
      });
    }
  })
});
