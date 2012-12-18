#!/usr/bin/env ruby
#
##script to check the unicorn backlog
#Slight modifications to https://github.com/petey5king/raindrops-nagios
#
##requires the nagios gem, raindrops and rubygems
require 'rubygems'
require 'raindrops'
require 'nagios'

class CheckRaindrops < Nagios::Plugin
    ADDRESS = "#{ENV['RAILS_ROOT']}/tmp/unicorn.sock"
    def warning (x)
      x > threshold(:warning)
    end

    def critical (x)
      x > threshold(:critical)
    end

    def measure
      @stats = Raindrops::Linux.unix_listener_stats([ADDRESS])
      @stats[ADDRESS].queued
    end

    def to_s(value)
      "QUEUE #{status}: #{@stats[ADDRESS].queued} | active=#{@stats[ADDRESS].active} queued=#{@stats[ADDRESS].queued}"
    end

end

CheckRaindrops.run!
