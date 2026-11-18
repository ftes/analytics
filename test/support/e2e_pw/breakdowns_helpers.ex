defmodule PlausibleE2E.BreakdownsHelpers do
  @moduledoc "Small shorthands for breakdowns.spec.ts, which repeats these statements throughout."

  alias Playwright.{Expect, Locator, Page}

  @doc "`await expect(button).toHaveAttribute('data-active', 'true')`"
  def expect_active(button), do: Expect.to_have_attribute!(button, "data-active", "true")

  @doc "`await expect(modal(page).getByRole('heading', { name })).toBeVisible()`"
  def expect_modal_heading(modal, name),
    do: modal |> Locator.get_by_role(:heading, name: name) |> Expect.to_be_visible!()

  @doc "`await report.getByTestId('report-end').scrollIntoViewIfNeeded()`"
  def scroll_to_end(report),
    do: report |> Locator.get_by_test_id("report-end") |> Locator.scroll_into_view_if_needed!()

  @doc "Clicks the filter pill's remove button."
  def remove_filter(page, name),
    do: page |> Page.get_by_role(:button, name: "Remove filter: " <> name) |> Locator.click!()

  @doc """
  `tabButton(page | report, label)`. PlausibleE2E.Utils.tab_button/2 only takes a page
  (`Page.get_by_test_id` on a Locator crashes), so breakdowns use this one.
  """
  def tab_button(%Playwright.Locator{} = report, label),
    do: report |> Locator.get_by_test_id("tab-button") |> Locator.filter(has_text: label)

  def tab_button(page, label),
    do: page |> Page.get_by_test_id("tab-button") |> Locator.filter(has_text: label)
end
