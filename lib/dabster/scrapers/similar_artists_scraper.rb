module Dabster
  class SimilarArtistsScraper

    def initialize
      @similar_artists_service = SimilarArtistsService.new(Artist)
    end

    def all(limit)
      artists = ::Artist.limit(limit).all
      create_progress_bar(artists.length)
      artists.each do |artist|
        @count += 1 if relate(artist)
        @progress_bar.increment
      end
      puts "Updated #{@count} out of #{@total} artists(s)"
    end

    def relate(artist)
      relationships = Whatcd::SimilarArtists.find(id: artist.whatcd_id)
      Sequel::Model.db.transaction do
        @similar_artists_service.relate_artists(artist, relationships)
      end
      true
    rescue StandardError => e
      msg = []
      msg << "#{e.class} (#{e.message})"
      msg << "Artist: #{artist.inspect}"
      msg += e.backtrace
      Dabster.log(:error, msg.join("\n"))
      false
    end

    private

    def create_progress_bar(total)
      @count = 0
      @total = total
      @progress_bar = ProgressBar.create(format: 'Elapsed %a Remaining %E |%B| %p%%', starting_at: 0, total: total)
    end

  end
end
