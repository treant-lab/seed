import Config

config :seed, Seed.Database.Repo,
  hostname: "192.168.12.188",
  basic_auth: [username: "neo4j", password: "treantlab123"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1
