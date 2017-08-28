defmodule LoadedBike.Web.FormHelpers do

  alias Phoenix.HTML.{Tag, Form}

  def text_input(form, field, opts \\ []) do
    generic_input(:text_input, form, field, opts)
  end

  def textarea(form, field, opts \\ []) do
    generic_input(:textarea, form, field, opts)
  end

  def form_group(form, field, opts \\ [], [do: block]) do
    state = state_class(form, field)
    Tag.content_tag :div, class: "form-group row #{opts[:class]} #{state}" do
      block
    end
  end

  # -- Private methods ---------------------------------------------------------

  defp generic_input(type, form, field, opts) do
    label   = label(form, field, opts)
    control = control(form, field, type, opts)
    form_group(form, field, opts) do
      [label, control]
    end
  end

  defp label(form, field, opts) do
    label_col   = Keyword.get(opts, :label_col, "col-sm-2 text-sm-right")
    label_text  = Keyword.get(opts, :label, Form.humanize(field))
    label_opts  = [class: "col-form-label #{label_col}"]

    Form.label(form, field, label_text, label_opts)
  end

  defp control(form, field, field_type, opts) do
    control_col   = Keyword.get(opts, :control_col, "col-sm-10")
    control_opts  = [class: control_col]

    input_opts = Keyword.get(opts, :input_opts, [])
    input_opts = Keyword.merge(input_opts, [class: "form-control"])

    input = apply(Phoenix.HTML.Form, field_type, [form, field, input_opts])

    Tag.content_tag :div, control_opts do
      [
        input,
        error_tag(form, field) || "",
        opts[:do] || ""
      ]
    end
  end

  defp state_class(form, field) do
    cond do
      form.errors[field]  -> "has-danger"
      true                -> ""
    end
  end

  defp error_tag(form, field) do
    if error = form.errors[field] do
      Tag.content_tag :div, LoadedBike.Web.TranslationHelpers.translate_error(error), class: "form-control-feedback"
    end
  end
end
