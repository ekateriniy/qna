class ActiveStorage::AttachmentsController < ApplicationController
  def destroy
    attachment.purge if current_user.owner?(attachment.record)
  end

  private

  helper_method :attachment

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
