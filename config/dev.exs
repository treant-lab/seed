import Config

config :seed, Seed.Database.Repo,
  hostname: "localhost",
  basic_auth: [username: "neo4j", password: "streams"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1
