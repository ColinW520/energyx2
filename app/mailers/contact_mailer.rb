class ContactMailer < ApplicationMailer
  default template_path: "mailers/contact_form_submissions"

  def contact_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(
      to: 'contact@energyxfitness.com',
      from: @email,
      subject: "New message from contact form on Energy X Fitness"
    )
  end
end
