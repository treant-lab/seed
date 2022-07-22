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
    template =
      get_all()
      |> Enum.find(&(&1.name == template_name))

    builded_template = generate_template(template, params)

    {:ok, builded_template}
  end

  defp generate_template(nil, _) do
    {:error, "Mail template not found"}
  end

  defp generate_template(%Template{} = template, _params) do
    {:ok, html} =
      template.file_path
      |> File.read!()
      |> Mjml.to_html()

    %{
      subject: template.default_subject,
      from: template.default_from,
      template: html
    }
  end
end
