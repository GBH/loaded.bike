defmodule LoadedBike.Web.FormHelpers do

  alias Phoenix.HTML.{Tag, Form}

  @label_col    "col-sm-2"
  @control_col  "col-sm-10"

  # Generating wrappers for default form helpers
  [:text_input, :file_input, :email_input, :password_input, :textarea]
    |> Enum.each(fn(method) ->
      def unquote(method)(form, field, opts \\ []) do
        generic_input(unquote(method), form, field, opts)
      end
    end)

  def radio_button(form, field, value, opts \\ []) do
    label = Keyword.get(opts, :label, Form.humanize(field))
    input = Form.radio_button(form, field, value, class: "form-check-input")
    Tag.content_tag :div, class: "form-check" do
      Tag.content_tag :label, class: "form-check-label" do
        [input, "\n", label]
      end
    end
  end

  def checkbox(form, field, opts \\ []) do
    label = Keyword.get(opts, :label, Form.humanize(field))
    input = Form.checkbox(form, field, class: "form-check-input")
    Tag.content_tag :div, class: "form-check" do
      Tag.content_tag :label, class: "form-check-label" do
        [input, "\n", label]
      end
    end
  end

  def form_group(form, field, opts \\ [], [do: block]) do
    state = state_class(form, field)

    label = Keyword.get(opts, :label, Form.humanize(field))
    label = Tag.content_tag :label, label, class: "#{label_col(form)} text-sm-right col-form-label"

    control = Tag.content_tag :div, class: control_col(form) do
      [block, error_tag(form, field) || ""]
    end

    Tag.content_tag :div, class: "form-group row #{opts[:class]} #{state}" do
      [label, control]
    end
  end

  # -- Private methods ---------------------------------------------------------

  defp label_col(form),   do: Keyword.get(form.options, :label_col, @label_col)
  defp control_col(form), do: Keyword.get(form.options, :control_col, @control_col)

  defp generic_input(type, form, field, opts) when is_atom(type) do
    label   = label(form, field, opts)
    control = control(form, field, type, opts)
    state   = state_class(form, field)

    Tag.content_tag :div, class: "form-group row #{state}" do
      [label, control]
    end
  end

  defp label(form, field, opts) do
    label_col   = Keyword.get(opts, :label_col, "#{label_col(form)} text-sm-right")
    label_text  = Keyword.get(opts, :label, Form.humanize(field))
    label_opts  = [class: "col-form-label #{label_col}"]

    Form.label(form, field, label_text, label_opts)
  end

  defp input_group(input, nil, nil), do: input
  defp input_group(input, prepend, append) do
    Tag.content_tag(:div, class: "input-group") do
      [input_group_addon(prepend), input, input_group_addon(append)]
    end
  end

  defp input_group_addon(nil), do: ""
  defp input_group_addon(content) do
    Tag.content_tag(:div, content, class: "input-group-addon")
  end

  defp help(nil), do: ""
  defp help(content) do
    Tag.content_tag(:small, content, class: "form-text text-muted")
  end

  defp control(form, field, field_type, opts) do
    control_col   = Keyword.get(opts, :control_col, control_col(form))
    control_opts  = [class: control_col]

    input_opts = Keyword.get(opts, :input_opts, [])
    input_opts = Keyword.merge(input_opts, [class: "form-control"])

    input = apply(Form, field_type, [form, field, input_opts])
      |> input_group(opts[:prepend], opts[:append])

    Tag.content_tag :div, control_opts do
      [
        input,
        help(opts[:help]),
        error_tag(form, field) || ""
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
      Tag.content_tag :div, LoadedBike.Web.ErrorHelpers.translate_error(error), class: "form-control-feedback"
    end
  end
end
