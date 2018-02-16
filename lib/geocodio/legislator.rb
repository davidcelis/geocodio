module Geocodio
  class Legislator
    attr_reader :type
    attr_reader :name
    attr_reader :birthday
    attr_reader :gender
    attr_reader :party
    attr_reader :url
    attr_reader :address
    attr_reader :phone
    attr_reader :contact_form
    attr_reader :rss_url
    attr_reader :twitter
    attr_reader :facebook
    attr_reader :youtube
    attr_reader :youtube_id
    attr_reader :bioguide_id
    attr_reader :thomas_id
    attr_reader :opensecrets_id
    attr_reader :lis_id
    attr_reader :cspan_id
    attr_reader :govtrack_id
    attr_reader :votesmart_id
    attr_reader :ballotpedia_id
    attr_reader :washington_post_id
    attr_reader :icpsr_id
    attr_reader :wikipedia_id

    def initialize(payload = {})
      @type = payload['type']

      if payload['bio']
        @name = "#{payload['bio']['first_name']} #{payload['bio']['last_name']}"
        @birthday = Date.new(*payload['bio']['birthday'].split('-').map(&:to_i))
        @gender = payload['bio']['gender']
        @party = payload['bio']['party']
      end

      if payload['contact']
        @url          = payload['contact']['url']
        @address      = payload['contact']['address']
        @phone        = payload['contact']['phone']
        @contact_form = payload['contact']['contact_form']
      end

      if payload['social']
        @rss_url    = payload['social']['rss_url']
        @twitter    = payload['social']['twitter']
        @facebook   = payload['social']['facebook']
        @youtube    = payload['social']['youtube']
        @youtube_id = payload['social']['youtube_id']
      end

      if payload['references']
        @bioguide_id        = payload['references']['bioguide_id']
        @thomas_id          = payload['references']['thomas_id']
        @opensecrets_id     = payload['references']['opensecrets_id']
        @lis_id             = payload['references']['lis_id']
        @cspan_id           = payload['references']['cspan_id']
        @govtrack_id        = payload['references']['govtrack_id']
        @votesmart_id       = payload['references']['votesmart_id']
        @ballotpedia_id     = payload['references']['ballotpedia_id']
        @washington_post_id = payload['references']['washington_post_id']
        @icpsr_id           = payload['references']['icpsr_id']
        @wikipedia_id       = payload['references']['wikipedia_id']
      end
    end
  end
end
