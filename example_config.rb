DiviningRod::Mappings.define(:format => :html) do |map|
    # Android based phones
    map.ua /Android/, :format => :webkit, :name => 'Android', :tags => [:android, :youtube_capable, :google_gears]

    # Apple iPhone OS
    map.ua /Apple.*Mobile.*Safari/, :format => :webkit, :tags => [:apple, :iphone_os, :youtube_capable] do |iphone|
      iphone.ua /iPad/, :tags => :ipad, :name => 'iPad'
      iphone.ua /iPod/, :tags => :ipod, :name => 'iPod Touch'
      iphone.ua /iPhone/, :tags => [:iphone], :name => 'iPhone'
    end

    #Blackberry, needs more detail here
    map.ua /BlackBerry/, :tags => :blackberry, :name => 'BlackBerry'

    # The desktop browsers, we don't set a format on these to let it pass through
    map.with_options :tags => :desktop do |desktop|
      desktop.ua /Chrome/, :tags => :chrome, :name => 'Chrome'
      desktop.ua /Firefox/, :tags => :firefox, :name => 'Firefox'
      desktop.ua /Safari/, :tags => :safari, :name => 'Safari'
      desktop.ua /Opera/, :tags => :opera, :name => 'Opera'
      desktop.ua /MSIE/, :tags => :ie, :name => 'Internet Explorer' do |msie|
        msie.ua /MSIE 5\.5/
        msie.ua /MSIE 6/, :version => 6
        msie.ua /MSIE 7/, :version => 7
        msie.ua /MSIE 8/, :version => 8
        msie.ua /MSIE 10/, :version => 10, :tags => :html5
      end
    end

    # Enable this to forces a default format if unmatched
    # otherwise it will return the request.format
    map.default :name => "Unknown"
end
