defmodule PlausibleE2E.ExportHelpers do
  @moduledoc "Helpers of csv-export.spec.ts: triggering the stats export and reading its zip."

  alias Playwright.{Download, Expect, Locator, Page}

  # Returns %{filename => content}. Upstream races the download against a `pageerror`, so a
  # page error fails fast; `expect_download!` here just waits for the download.
  def trigger_export_and_await_download(page) do
    Page.get_by_test_id(page, "dashboard-options-menu") |> Locator.click!()
    Page.get_by_text(page, "Export stats") |> Locator.wait_for!(state: :visible)

    download =
      Page.expect_download!(page, fn ->
        Page.get_by_text(page, "Export stats") |> Locator.click!()
      end)

    zip_path = Download.path!(download)
    if !zip_path, do: raise("Download path unavailable")

    {:ok, files} = :zip.unzip(String.to_charlist(zip_path), [:memory])
    Map.new(files, fn {name, data} -> {List.to_string(name), data} end)
  end

  def parse_all_csvs(files) do
    Map.new(files, fn {filename, content} ->
      rows =
        content
        |> String.split(~r/\r?\n/)
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.split(&1, ","))

      {filename, rows}
    end)
  end

  def get_csv(csvs, filename) do
    case csvs do
      %{^filename => rows} -> rows
      _ -> raise "Expected #{filename} in CSV export"
    end
  end

  def expect_remove_filter_button(page, name),
    do: Expect.to_be_visible!(Page.get_by_role(page, :button, name: name))
end
