import Config

config :seed, Seed.Database.Repo,
  hostname: "baas-neo4j.treantlab",
  basic_auth: [username: "neo4j", password: "treantlab123"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1
