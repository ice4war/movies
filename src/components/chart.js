import * as d3 from "d3";

export function Chart() {
  const width = 500;
  const height = width * 0.8;
  const data = [
    { category: "A", value: 30 },
    { category: "B", value: 80 },
    { category: "C", value: 45 },
    { category: "D", value: 60 },
    { category: "E", value: 20 },
    { category: "F", value: 95 },
  ];
  let canvas = d3
    .create("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("id", "canvas");
  const x = d3
    .scaleBand()
    .domain(data.map((d) => d.category))
    .range([0, width])
    .padding(0.2);
  const y = d3
    .scaleLinear()
    .domain([0, d3.max(data, (d) => d.value)])
    .range([height, 0]);
  canvas
    .append("g")
    .selectAll(".bar")
    .data(data)
    .join("rect")
    .attr("class", "bar")
    .attr("x", (d) => x(d.category))
    .attr("y", (d) => y(d.value))
    .attr("width", x.bandwidth())
    .attr("height", (d) => height - y(d.value))
    .attr("fill", "red");
  return canvas.node();
}
