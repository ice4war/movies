---
toc: false
sidebar: false
---

<div class="hero">
  <h1>Movies</h1>
  <h2>Welcome to your new app! Edit&nbsp;<code style="font-size: 90%;">src/index.md</code> to change this page.</h2>
</div>

```js
import * as d3 from "d3";
const movies = await FileAttachment("./data/final.json").json();
const unique_years = [...new Set(movies.map((d) => d.year))].sort(
  (a, b) => b - a,
);
const years = Inputs.select(unique_years, {
  value: unique_years[0],
});
const year = Generators.input(years);
const selected_movies = movies
  .filter((d) => d.year === 2025)
  .sort((a, b) => new Date(b.updated) - new Date(a.updated));
```

```js
import { card } from "./components/card.js";
```

${years}

<!--${display(Inputs.table(selected_movies))}-->

<ul>
${selected_movies.map(d=>card(d))}
</ul>
