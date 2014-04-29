require 'eventmachine'

module Dabster
  module Playback
    class XMMSConnection < EM::Connection

      def initialize(xmms_client)
        @xmms = xmms_client
        @xmms.io_on_need_out { |need_out| need_out_callback(need_out) }
      end

      def post_init
        need_out_callback(true) if @xmms.io_want_out
      end

      def notify_readable
        @xmms.io_in_handle
      end

      def notify_writable
        @xmms.io_out_handle
      end
      
      def unbind
        @xmms.io_disconnect
      end

      private

      def need_out_callback(flag)
        # Due to issue with XMMS, flag is 0 for false and true for true
        need_out = flag == 0 ? false : true

        if need_out && !notify_writable?
          self.notify_writable = true
        elsif !need_out
          self.notify_writable = false
        end
      end

    end
  end
end
