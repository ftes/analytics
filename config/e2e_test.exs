import Config

config :plausible, PlausibleWeb.Endpoint,
  server: true,
  check_origin: false

config :plausible,
  paddle_classic_api: Plausible.Billing.PaddleClassic.DevApiMock,
  google_api: Plausible.Google.API.Mock,
  verification_checks_mod: Plausible.InstallationSupport.Verification.ChecksMock

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :bcrypt_elixir, :log_rounds, 4

config :plausible, Plausible.Ingestion.Counters, enabled: false

config :plausible, Oban, testing: :manual

config :plausible, Plausible.Session.Salts, interval: :timer.hours(1)

# Browser suite in test/e2e_pw (playwright_ex), a port of e2e/. The app runs in the test VM.
config :playwright, :test,
  context_options: [
    base_url: System.get_env("BASE_URL", "http://localhost:8111"),
    # Sets single TZ for all envs where the tests run
    timezone_id: "UTC",
    viewport: %{width: 1280, height: 720}
  ],
  trace: :retain_on_failure,
  screenshot: :only_on_failure
