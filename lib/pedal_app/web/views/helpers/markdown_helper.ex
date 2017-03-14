defmodule PedalApp.Web.MarkdownHelper do

  def markdown(nil), do: ""
  def markdown(body) do
    {_, html, _} = Earmark.as_html(body)
    HtmlSanitizeEx.markdown_html(html)
    |> Phoenix.HTML.raw
  end
end