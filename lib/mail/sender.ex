defmodule Seed.Mail.Sender do
  alias Seed.Mail.Sender.Templates
  import Bamboo.Email

  def send_default_template({template_name, %{to: to}}) do
    case Templates.generate({template_name, %{to: to}}) do
      {:ok, %{subject: subject, from: from, template: template}} ->
        base_email()
        |> from(from)
        |> to(to)
        |> subject(subject)
        |> html_body(template)
      error ->
        error
    end
  end

  defp base_email do
    new_email()
  end
end
