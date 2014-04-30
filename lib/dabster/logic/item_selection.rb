module Dabster
  module Logic
    module ItemSelection

      def least_played_item
        random_unplayed_item || least_recently_played_item
      end

    end
  end
end
