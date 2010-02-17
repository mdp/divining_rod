# Divining Rod

A tool to help format your sites mobile pages. The goal is to have the ability to do things in your
views like this

    <%- if request.dv_profile.youtube_capable? %>
      <%= link_to "YouTube Video", @link.youtube_url %>
    <%- else %>
      Sorry, you have a shitty phone.
    <% end %>

## Installation

    gem install divining_rod
    
## Usage

    require 'divining_rod'

    DiviningRod::Matchers.define do |map|
        map.ua /iPhone/, :webkit, :tags => [:iphone, :youtube_capable]
        map.ua /Android/, :webkit, :tags => [:youtube_capable, :google_gears]
        map.default :unknown
    end
    
    profile = DiviningRod::Profile(request) #profile and incoming iphone request
    profile.format #=> :webkit
    profile.iphone? #=> true
    
## Note on the development

This is still very much in beta, but we are using in extensively in production. We plan
to keep the API the same.

The user agent definitions will be updated here later this week.


### Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright (c) 2010 Mark Percival. See LICENSE for details.
