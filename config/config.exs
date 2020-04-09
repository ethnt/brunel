import Config

config :brunel, Brunel.Repo,
  adapter: Sqlite.Ecto2,
  database: "brunel.sqlite3"

config :brunel, ecto_repos: [Brunel.Repo]
