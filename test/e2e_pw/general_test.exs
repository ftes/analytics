defmodule PlausibleE2E.Dashboard.GeneralTest do
  use PlausibleE2E.Case, async: true

  test "dashboard renders for logged in user", %{page: page, request: request} do
    %{domain: domain} = setup_site(page: page, request: request)
    populate_stats(request: request, domain: domain, events: [%{name: "pageview"}])

    Page.goto!(page, "/" <> domain, wait_until: :commit)

    Expect.to_have_title!(page, ~r/Plausible/)

    Expect.to_be_visible!(Page.get_by_role(page, :button, name: domain))
  end
end
