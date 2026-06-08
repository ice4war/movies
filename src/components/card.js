import * as d3 from "d3";
export function card(data) {
  const element = d3.create("li").attr("class", "card");
  const content = element.append("div").attr("class", "content");
  content.append("span").attr("class", "genre").text(data.genre[0]);
  const main = content.append("div");
  main
    .append("a")
    .attr("href", data.url)
    .attr("target", "_blank")
    .append("img")
    .attr("src", `https://moviesda31.com${data.poster}`);
  main
    .append("a")
    .attr("href", data.url)
    .attr("target", "_blank")
    .append("p")
    .text(data.name);
  const cast = content.append("p").attr("class", "cast");
  cast.append("strong").text("Starring:");
  cast.append("span").text(data.cast);
  const director = content.append("p").attr("class", "director");
  director.append("strong").text("Director:");
  director.append("span").text(data.director);
  return element.node();
}
