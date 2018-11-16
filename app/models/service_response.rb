class ServiceResponse
  attr_accessor :message, :object, :path, :success

  def initialize(message:, object:, path:, success:)
    @message = message
    @object = object
    @path = path
    @success = success
  end

  def flash_status
    if success
      :success
    else
      :notice
    end
  end

  def flash_message
    message
  end

  def view_to_render
    path
  end
end
