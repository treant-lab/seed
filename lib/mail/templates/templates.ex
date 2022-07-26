defmodule Seed.Mail.Sender.Templates do
  alias Seed.Mail.Template

  def get_all() do
    [
      %Template{
        name: :welcome,
        default_subject: "Welcome",
        default_from: "noreplay@treantlabs.com",
        file_path: "lib/mail/templates/authentication/welcome.mjml"
      }
    ]
  end

  def generate({template_name, params}) do
    with template when is_struct(template, Template) <-
           Enum.find(get_all(), &(&1.name == template_name)),
         builded_template <- generate_template(template, params) do
      {:ok, builded_template}
    else
      nil -> {:error, :template_not_found}
      _ -> {:error, "Unexpected error"}
    end
  end

  defp generate_template(%Template{} = template, params) do
    {:ok, html} =
      template.file_path
      |> File.read!()
      |> replace_variables(params)
      |> Mjml.to_html()

    %{
      subject: template.default_subject,
      from: template.default_from,
      template: html
    }
  end

  defp replace_variables(text, params) do
    Map.keys(params)
    |> Enum.reduce(text, &String.replace(&2, "{{ #{&1} }}", params[&1], global: true))
  end
end
