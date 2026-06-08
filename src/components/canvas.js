import * as d3 from "d3";

export function CanvasChart() {
  const width = 500;
  const height = width;
  const data = [
    { category: "A", value: 30 },
    { category: "B", value: 80 },
    { category: "C", value: 45 },
    { category: "D", value: 60 },
    { category: "E", value: 20 },
    { category: "F", value: 95 },
  ];
  let canvas = d3
    .create("canvas")
    .attr("width", width)
    .attr("height", height)
    .attr("id", "canvas");
  let context = canvas.node().getContext("2d");
  context.clearRect(0, 0, width, height);
  const x = d3
    .scaleLinear()
    .domain([0, d3.max(data, (d) => d.value)])
    .range([0, width]);
  const y = d3
    .scaleLinear()
    .domain([d3.max(data, (d) => d.value), 0])
    .range([height, 0]);

  data.forEach((d, i) => {
    context.fillStyle = "salmon";
    context.beginPath();
    context.arc(i * 50, y(d.value), 20, 0, 2 * Math.PI, true);
    context.fill();
    context.closePath();
  });
  // const binding = d3.create("custom");
  // const nodes = binding
  //   .selectAll()
  //   .data(data)
  //   .join("rect")
  //   .attr("x", (d) => x(d.category))
  //   .attr("y", (d) => y(d.value))
  //   .attr("width", x.bandwidth())
  //   .attr("height", (d) => height - y(d.value));
  // nodes.each(function (d) {
  //   const node = d3.select(this);
  //   //Drawing Text
  //   context.fillStyle = "red";
  //   context.fillRect(
  //     node.attr("x"),
  //     node.attr("y"),
  //     node.attr("width"),
  //     node.attr("height"),
  //   );
  //   context.fillText(d.category, node.attr("x"), node.attr("y"));
  // });
  return canvas.node();
}
