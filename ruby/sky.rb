require "skyscanner"
require "json"
require "active_record"

Skyscanner::Connection.apikey  = "prtl6749387986743898559646983194"
$live = true

$carriers = {} 
$places = {} 
class Quotes
  attr_accessor :quotes

    def sort_by!(array)
    quotes.sort_by! do |q|
      array.map { |item|  q.send item.to_sym }
    end
    self
  end  
  
  def reject_single_fight!
    quotes.reject! do |q|
      quotes.select { |q1| q1.departure_date == q.departure_date }.size <=1
    end
    self
  end 
  
  def cheaper_than! price
    quotes.reject! do |q|
      q.min_price > price
    end
    self
  end 

  def initialize(hash)
    @quotes = []
    return if hash == nil
      
    raise "Error : #{hash}" if hash[:status] == 429
    hash["Places"].map do |p| Place.new(p) end.each do |place| $places[place.id] = place end
    hash["Carriers"].map do |c| Carrier.new(c) end.each do |carrier| $carriers[carrier.id] = carrier end
    
    @quotes = hash["Quotes"].map do |q|  Quote.new(q)    end
  end
  
  def self.find(options={})
   defaults = { :country => "GB", 
        :currency => "GBP", 
        :locale => "en-GB", 
        :originPlace => "EDI", 
        :destinationPlace => "LIG", 
        :outboundPartialDate => "anytime"}
    if $live
      result = nil
      loop do 
        result  = Skyscanner::Connection.browse_quotes( defaults.merge(options) )
        if result[:status] == 429
          print "."
          sleep 3
        else
          print "+"
          break
        end
      end  
    else
      result  = JSON.parse(File.read("flight.json"));
    end

    Quotes.new result
  end
  
  def self.multi_find(queries=[])
    quotes = Quotes.new(nil)
    queries.each do |q|
      quotes.quotes << Quotes.find(q).quotes
    end
    quotes.quotes.flatten!
    puts " [Ok]"
    quotes
  end
  
  def output
    self.quotes.map do |q|
      q.output
    end.join "\n"
  end
end

class Quote
    attr_accessor :id, :min_price,  :direct,  :outbound_leg
    def initialize(hash)
      @id =  hash["QuoteId"]
      @min_price =  hash["MinPrice"]
      @direct =  hash["Direct"]
      @outbound_leg =  Leg.new(hash["OutboundLeg"])
    end
    
    def bar(float)
      out  =""
      (float/10).to_i.times do |i|
        out << "#"
      end
      out[0..18]
    end

    def departure_date
      self.outbound_leg.departure_date
    end 
    
    def date
      self.outbound_leg.departure_date
    end
    def price
      self.min_price
    end  

    def from
      self.outbound_leg.origin.name
    end
    
    def output
      sprintf("[%8s] [%-20s %5s] : %s", self.outbound_leg.departure_date.strftime("%a %d/%m"), bar(self.min_price) ,self.min_price , "#{self.outbound_leg.origin.name} => #{self.outbound_leg.destination.name} ( #{self.outbound_leg.carriers.join ','} )")
    end
end


class  Leg
  attr_accessor :departure_date, :origin,  :destination,  :carriers
  def initialize(hash)
    @departure_date =  Date.iso8601(hash["DepartureDate"]) 
    @origin =  $places[hash["OriginId"]]
    @destination =  $places[hash["DestinationId"]]
    @carriers =  hash["CarrierIds"].map do |id| $carriers[id] end
  end
  
  def carrier
    @carriers[0]
  end


end


class Place
  attr_accessor :id, :code,  :name,  :city,  :country
  def initialize(hash)
    @id = hash["PlaceId"]
    @code = hash["IataCode"]
    @name= hash["Name"]
    @city = hash["CityName"]
    @country = hash["CountryName"]
  end
  
  def to_s
    @name
  end 
end

class  Carrier
  attr_accessor :id, :name 
  def initialize(hash)
    @id =  hash["CarrierId"]
    @name =  hash["Name"]
  end
  def to_s
    @name
  end 
end




# r =  Quotes.multi_find( [
#     {:originPlace => "EDI", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "EDI", :destinationPlace => "PIS", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "PIS", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "EDI", :destinationPlace => "BVE", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "BVE", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "EDI", :destinationPlace => "BOD", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "BOD", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "EDI", :destinationPlace => "PARI", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "PARI", :outboundPartialDate => "2015-06"  },
#   ]
# ).cheaper_than!(200).sort_by_price!

#r =  Quotes.multi_find( [
#    {:originPlace => "EDI", :destinationPlace => "STN", :outboundPartialDate => "2015-05"  },
#    {:originPlace => "STN", :destinationPlace => "LIG", :outboundPartialDate => "2015-05"  },
#    {:originPlace => "EDI", :destinationPlace => "STN", :outboundPartialDate => "2015-06"  },
#    {:originPlace => "STN", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#  ]
#).cheaper_than!(75).reject_single_fight!.sort_by_date!

#puts "\n\Allee:\n"
#r =  Quotes.multi_find( [
#    {:originPlace => "EDI", :destinationPlace => "STN", :outboundPartialDate => "2015-06"  },
#    {:originPlace => "STN", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#  ]
#).cheaper_than!(75).reject_single_fight!.sort_by! [ :date,  :from]
#
#puts r.output
#
#puts "\n\nRetour:\n"
#r =  Quotes.multi_find( [
#    {:originPlace => "LIG", :destinationPlace => "STN", :outboundPartialDate => "2015-06"  },
#    {:originPlace => "STN", :destinationPlace => "EDI", :outboundPartialDate => "2015-06"  },
#  ]
#).cheaper_than!(75).reject_single_fight!.sort_by! [ :date,  :from]
#
#puts r.output



# r =  Quotes.multi_find( [
#     {:originPlace => "EDI", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "LIG", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "EDI", :destinationPlace => "PIS", :outboundPartialDate => "2015-06"  },
#     {:originPlace => "GLAS", :destinationPlace => "PIS", :outboundPartialDate => "2015-06"  },
#   ]
# ).cheaper_than!(75).sort_by! [ :date, :price]
#
# r =  Quotes.multi_find( [
#     {:originPlace => "EDI", :destinationPlace => "SYD", :outboundPartialDate => "2015-09"  },
#     {:originPlace => "EDI", :destinationPlace => "SYD", :outboundPartialDate => "2015-10"  },
#     {:originPlace => "EDI", :destinationPlace => "SYD", :outboundPartialDate => "2015-11"  },
#     {:originPlace => "EDI", :destinationPlace => "SYD", :outboundPartialDate => "2015-12"  },
#   ]
# ).sort_by! [:price]


#puts Quotes.multi_find( [
#    {:originPlace => "BVA", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-08"  },
#    {:originPlace => "BVA", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-09"  },
#    {:originPlace => "BVA", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-10"  },
#    {:originPlace => "BVA", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-11"  },
#    {:originPlace => "CDG", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-08"  },
#    {:originPlace => "CDG", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-09"  },
#    {:originPlace => "CDG", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-10"  },
#    {:originPlace => "CDG", :destinationPlace => "EDI", :outboundPartialDate => "2015-08-11"  },
#   
#  ]
#).sort_by!([ :price]).output

# return
# puts Quotes.multi_find( [
#     {:originPlace => "FR", :destinationPlace => "EDI", :outboundPartialDate => "2015-05-30"  },
#     {:originPlace => "FR", :destinationPlace => "EDI", :outboundPartialDate => "2015-05-31"  },
#     {:originPlace => "FR", :destinationPlace => "EDI", :outboundPartialDate => "2015-06-01"  },
#     {:originPlace => "FR", :destinationPlace => "EDI", :outboundPartialDate => "2015-06-02"  },
#     
#     {:originPlace => "LIG", :destinationPlace => "UK", :outboundPartialDate => "2015-05-30"  },
#     {:originPlace => "LIG", :destinationPlace => "UK", :outboundPartialDate => "2015-05-31"  },
#     {:originPlace => "LIG", :destinationPlace => "UK", :outboundPartialDate => "2015-06-01"  },
#     {:originPlace => "LIG", :destinationPlace => "UK", :outboundPartialDate => "2015-06-02"  },
#    
#   ]
# ).sort_by!([  :date, :price]).output

# way in
puts Quotes.multi_find( [
    {:originPlace => "EDI", :destinationPlace => "FR", :outboundPartialDate => "2015-05-22"  },
    {:originPlace => "EDI", :destinationPlace => "FR", :outboundPartialDate => "2015-05-23"  },
    {:originPlace => "EDI", :destinationPlace => "FR", :outboundPartialDate => "2015-05-24"  },
    {:originPlace => "EDI", :destinationPlace => "FR", :outboundPartialDate => "2015-05-25"  },
    
    {:originPlace => "UK", :destinationPlace => "LIG", :outboundPartialDate => "2015-05-22"  },
    {:originPlace => "UK", :destinationPlace => "LIG", :outboundPartialDate => "2015-05-23"  },
    {:originPlace => "UK", :destinationPlace => "LIG", :outboundPartialDate => "2015-05-24"  },
    {:originPlace => "UK", :destinationPlace => "LIG", :outboundPartialDate => "2015-05-25"  },
   
  ]
).sort_by!([  :date, :price]).output


