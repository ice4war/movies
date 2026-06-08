import * as d3 from "d3";

export function Circle(data) {
  const width = 900;
  const height = width * 0.8;

  let canvas = d3
    .create("canvas")
    .attr("width", width)
    .attr("height", height)
    .attr("id", "canvas");
  let context = canvas.node().getContext("2d");
  const color = d3
    .scaleLinear()
    .domain([0, 5])
    .range(["hsl(152,80%,80%)", "hsl(228,30%,40%)"])
    .interpolate(d3.interpolateHcl);
  const pack = (data) =>
    d3.pack().size([width, height]).padding(3)(
      d3
        .hierarchy(data)
        .sum((d) => d.size)
        .sort((a, b) => b.value - a.value),
    );
  const root = pack(data);
  root.descendants().forEach((d) => {
    context.fillStyle = d.children ? color(d.depth) : "white";
    context.beginPath();
    context.arc(d.x, d.y, d.r, 0, 2 * Math.PI, true);
    context.fill();
    context.closePath();
  });

  return canvas.node();
}
