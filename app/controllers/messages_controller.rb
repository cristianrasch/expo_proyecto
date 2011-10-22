class MessagesController < ApplicationController
  before_filter :ensure_admin_logged_in!
  before_filter :fetch_source
  
  def new
    @message = Message.new(:source => @source)
  end

  def create
    @message = Message.new(params[:message])
    
    if @message.valid?
      MessagesMailer.new_message(@message).deliver
      redirect_to redirect_page, :notice => "Mensaje enviado!"
    else
      @message.source = @source
      render :new
    end
  end
  
  private
  
  def fetch_source
    arr = params.find { |k, v| k =~ /(.+)_id$/ }
    @source = $1.classify.constantize.find(arr.last)
  end
  
  def redirect_page
    case(@source)
      when Exposition then exposition_path(@source.year)
      when Project then project_path(@source)
    end
  end
end
