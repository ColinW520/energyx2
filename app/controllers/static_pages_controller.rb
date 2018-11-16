class StaticPagesController < ApplicationController
  layout :resolve_layout
  skip_before_action :authenticate_user!

  def home
    @articles_available = Article.available.any?
  end

  def join
  end

  def instagram
    client = Instagram.client(access_token: ENV['INSTAGRAM_TOKEN'])
    @posts = client.user_recent_media.first(2)
  end

  def nutrition
  end

  def contact
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    @spam_check = params[:spam_check]

    unless @spam_check == 'gotcha.'
      flash[:alert] = 'We think this might be spam... Call us if you disagree!'
      redirect_to root_path and return
    end

    if @name.blank?
      flash[:danger] = 'Please enter your name before sending your message. Thank you.'
    elsif @email.blank? || @email.scan(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).size < 1
      flash[:danger] = 'You must provide a valid email address before sending your message. Thank you.'
    elsif @message.blank? || @message.length < 10
      flash[:danger] = 'Your message is empty. Requires at least 10 characters. Nothing to send.'
    elsif @message.scan(/<a href=/).size > 0 || @message.scan(/\[url=/).size > 0 || @message.scan(/\[link=/).size > 0 || @message.scan(/http:\/\//).size > 0
      flash[:danger] = "Please don't include links. Spammers do this. Thank you for your understanding."
    else
      ContactMailer.contact_message(@name, @email, @message).deliver
      flash[:success] = 'Your message was sent! We will get back to you shortly.'
    end

    redirect_to root_path
  end

  def pricing
  end

  def terms
  end

  def resolve
    @event = Event.where("name ILIKE ?", "Resolve to Row").last
  end

  private

  def resolve_layout
    case action_name
    when "resolve"
      "bare"
    when "instagram"
      nil
    else
      "static_views"
    end
  end
end
