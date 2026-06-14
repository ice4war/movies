import * as d3 from "d3";
export function card(data) {
  // const element = d3.create("li").attr("class", "movie-card");
  // const content = element.append("div").attr("class", "content");
  // content.append("span").attr("class", "genre").text(data.genre[0]);
  // const main = content.append("div");
  // main
  //   .append("a")
  //   .attr("href", data.url)
  //   .attr("target", "_blank")
  //   .append("img")
  //   .attr("loading", "lazy")
  //   .attr("src", data.poster);
  // main
  //   .append("a")
  //   .attr("href", data.url)
  //   .attr("target", "_blank")
  //   .append("p")
  //   .text(data.name);
  // const cast = content.append("p").attr("class", "cast");
  // cast.append("strong").text("Starring:");
  // cast.append("span").text(data.cast);
  // const director = content.append("p").attr("class", "director");
  // director.append("strong").text("Director:");
  // director.append("span").text(data.director);
  const element = d3.create("li").attr("class", "container");
  const movie = element.append("div").attr("class", "movie");
  movie
    .append("a")
    .attr("href", data.url)
    .attr("target", "_blank")
    .append("img")
    .attr("class", "movie-img")
    .attr("src", data.poster)
    .attr("loading", "lazy");
  const content = movie.append("div").attr("class", "text-movie-cont");
  content
    .append("a")
    .attr("class", "movie-title")
    .attr("href", data.url)
    .attr("target", "_blank")
    .text(data.name);
  const details = content.append("div").attr("class", "details");
  details.append("p").attr("class", "movie-gen").text(data.genre);
  details.append("p").attr("class", "movie-actors").text(data.cast);
  details.append("p").attr("class", "movie-director").text(data.director);

  return element.node();
}
// <div class="container">
//   <div class="movie">
//     <img class="movie-img" src="" />
//     <div class="text-movie-cont">
//       <h1>Interstellar</h1>
//       <ul class="movie-gen">
//         <li>PG-13 /</li>
//         <li>2h 49min /</li>
//         <li>Adventure, Drama, Sci-Fi,</li>
//       </ul>
//       <div class="flex">
//         <h5 class="summary-row">SUMMARY</h5>
//         <p class="movie-description"></p>
//       </div>
//       <p class="movie-actors">
//         Matthew McConaughey, Anne Hathaway, Jessica Chastain
//       </p>
//     </div>
//   </div>
// </div>;
