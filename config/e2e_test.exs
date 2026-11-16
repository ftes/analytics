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
  # as the original on CI
  workers: 4,
  context_options: [
    base_url: System.get_env("BASE_URL", "http://localhost:8111"),
    # Sets single TZ for all envs where the tests run
    timezone_id: "UTC",
    viewport: %{width: 1280, height: 720}
  ],
  # The original traces only on a retry; tracing every test is ~30% slower. For debugging:
  # PW_TRACE=retain_on_failure PW_SCREENSHOT=only_on_failure mix test test/e2e_pw
  trace: String.to_atom(System.get_env("PW_TRACE", "off")),
  screenshot: String.to_atom(System.get_env("PW_SCREENSHOT", "off"))
