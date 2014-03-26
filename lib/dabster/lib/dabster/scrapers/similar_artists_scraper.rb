class SimilarArtistsScraper

  def initialize
    @similar_artists_service = SimilarArtistsService.new(Artist)
  end

  def all(limit)
    artists_ds = ::Artist.order(:id).limit(limit)
    create_progress_bar(artists_ds.count)
    artists_ds.paged_each do |artist|
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
    File.open(Dabster.log, 'a') do |file|
      file.puts "#{e.class} (#{e.message})"
      file.puts "Artist: #{artist.inspect}"
      file.puts e.backtrace.join("\n")
      file.write "\n"
    end
    false
  end

  private

  def create_progress_bar(total)
    @count = 0
    @total = total
    @progress_bar = ProgressBar.create(format: 'Elapsed %a Remaining %E |%B| %p%%', starting_at: 0, total: total)
  end

end
