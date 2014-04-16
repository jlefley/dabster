module Dabster
  module Playback
    class XMMSConnection < EM::Connection

      def initialize(xmms_client)
        @xmmsc = xmms_client
        @xmmsc.io_on_need_out { |need_out| need_out_callback(need_out) }
      end

      def post_init
        need_out_callback(true) if @xmmsc.io_want_out
      end

      def notify_readable
        @xmmsc.io_in_handle
      end

      def notify_writable
        @xmmsc.io_out_handle
      end
      
      def unbind
        @xmmsc.io_disconnect
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
