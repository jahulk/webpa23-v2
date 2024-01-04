class MessagesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index]

  def index
    @messages = Message.all.order(created_at: :desc)
    @message = Message.new
  end

  def create
    @messages = Message.all.order(created_at: :desc)
    @message = Message.new(message_params)
    @message.user = current_user

    respond_to do |format|
      if @message.save
        redirect_to chat_path
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end