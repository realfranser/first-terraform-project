import express from "express";

const DEFAULT_PORT = 3000;

const app = express();

app.get("/", (req, res) => {
  res.send("Hello there!");
});

app.listen(DEFAULT_PORT, () => {
  console.log(`Exaple app listening on port ${DEFAULT_PORT}`);
});
