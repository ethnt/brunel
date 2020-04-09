import Config

config :brunel, Brunel.Repo,
  database: "brunel_dev",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :brunel, ecto_repos: [Brunel.Repo]
