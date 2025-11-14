class SyncChannel < ApplicationCable::Channel
  include Y::Actioncable::Sync

  def subscribed
    sync_for(document)
  end

  def receive(message)
    sync_to(document, message)
  end

  private
    def document
      Document.find_by_sqid!(params[:id])
    end
end
