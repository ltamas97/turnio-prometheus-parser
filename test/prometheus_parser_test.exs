defmodule PrometheusParserTest do
  use ExUnit.Case
  import PrometheusParser

  test "parse comment" do
    assert parse("# Some documenting text") ==
             %PrometheusParser.Line{
               documentation: "Some documenting text",
               line_type: "COMMENT"
             }
  end

  test "write comment" do
    assert to_string(%PrometheusParser.Line{
             documentation: "Some documenting text",
             line_type: "COMMENT"
           }) == "# Some documenting text"
  end

  test "parse help" do
    assert parse("# HELP web_uptime Number of seconds since web server has started") ==
             %PrometheusParser.Line{
               documentation: "Number of seconds since web server has started",
               label: "web_uptime",
               line_type: "HELP"
             }
  end

  test "write help" do
    assert to_string(%PrometheusParser.Line{
             documentation: "Number of seconds since web server has started",
             label: "web_uptime",
             line_type: "HELP"
           }) == "# HELP web_uptime Number of seconds since web server has started"
  end

  test "parse type" do
    assert parse("# TYPE web_uptime gauge") ==
             %PrometheusParser.Line{label: "web_uptime", line_type: "TYPE", type: "gauge"}
  end

  test "write type" do
    assert to_string(%PrometheusParser.Line{label: "web_uptime", line_type: "TYPE", type: "gauge"}) ==
             "# TYPE web_uptime gauge"
  end

  test "parse entry" do
    assert parse("web_connections{node=\"abc-123-def-0\"} 607180") ==
             %PrometheusParser.Line{
               documentation: nil,
               label: "web_connections",
               line_type: "ENTRY",
               pairs: [{"node", "abc-123-def-0"}],
               timestamp: nil,
               type: nil,
               value: "607180"
             }
  end

  test "write entry" do
    assert to_string(%PrometheusParser.Line{
             documentation: nil,
             label: "web_connections",
             line_type: "ENTRY",
             pairs: [{"node", "abc-123-def-0"}],
             timestamp: nil,
             type: nil,
             value: "607180"
           }) ==
             "web_connections{node=\"abc-123-def-0\"} 607180"
  end

  test "parse entry with multiple keys and value" do
    assert parse("web_connections{node=\"abc-123-def-0\", bar=\"baz\"} 607180") ==
             %PrometheusParser.Line{
               documentation: nil,
               label: "web_connections",
               line_type: "ENTRY",
               pairs: [{"node", "abc-123-def-0"}, {"bar", "baz"}],
               timestamp: nil,
               type: nil,
               value: "607180"
             }
  end

  test "write entry with multiple keys and values" do
    assert to_string(%PrometheusParser.Line{
             documentation: nil,
             label: "web_connections",
             line_type: "ENTRY",
             pairs: [{"node", "abc-123-def-0"}, {"bar", "baz"}],
             timestamp: "1234",
             type: nil,
             value: "607180"
           }) ==
             "web_connections{node=\"abc-123-def-0\", bar=\"baz\"} 607180 1234"
  end

  test "parse entry with timestamp" do
    assert parse("web_connections{node=\"abc-123-def-0\"} 607180 200") ==
             %PrometheusParser.Line{
               documentation: nil,
               label: "web_connections",
               line_type: "ENTRY",
               pairs: [{"node", "abc-123-def-0"}],
               timestamp: "200",
               type: nil,
               value: "607180"
             }
  end

  test "write entry with timestamp" do
    assert to_string(%PrometheusParser.Line{
             documentation: nil,
             label: "web_connections",
             line_type: "ENTRY",
             pairs: [{"node", "abc-123-def-0"}],
             timestamp: "1234",
             type: nil,
             value: "607180"
           }) ==
             "web_connections{node=\"abc-123-def-0\"} 607180 1234"
  end
end