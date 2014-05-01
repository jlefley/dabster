module TestSupport
  module XmmsClientHelper

    def change_queue_position(new_position)
      $client.change_current_position(new_position)
    end
    
    def client
      $client
    end

  end
end
