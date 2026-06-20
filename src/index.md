---
toc: false
sidebar: false
---

<div class="hero">
  <h1></h1>
  <h2>Search your favourite Movies!</h2>
</div>

```js
import { card } from "./components/card.js";
const movieData = await FileAttachment("./data/final.json").json();
```

```js
const unique_years = [...new Set(movies.map((d) => d.year)).add("All")].sort(
  (a, b) => b - a,
);
const select_year = Inputs.select(unique_years, {
  value: "2026",
});
const selected_year = Generators.input(select_year);
```

```js
// const movies = movieData.filter((e) => e.updated !== null);
const movies = movieData;
```

```js
const selected_movies =
  selected_year === "All"
    ? movies
    : movies
        .filter((d) => d.year === selected_year)
        .sort((a, b) => new Date(b.updated) - new Date(a.updated));
const search = Inputs.search(selected_movies, {
  placeholder: "Search Movie...",
  columns: ["name"],
  autocomplete: false,
  disabled: false,
  format: (e) => "",
});
const searched_movie = Generators.input(search);
```

<div class="search-nav">
${search}
${select_year}
</div>

<ul>
${searched_movie.map(d=>card(d))}
</ul>
