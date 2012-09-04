#!/usr/bin/env ruby
module Nagios
  class Vmstat
    attr_accessor :warning_cs, :warning_free, :critical_cs, :critical_free

    def initialize
      warning_index = ARGV.index('-wcs')
      @warning_cs = !!warning_index ? ARGV[warning_index+1].to_i : 75

      critical_index = ARGV.index('-ccs')
      @critical_cs = !!critical_index ? ARGV[critical_index+1].to_i : 90

      warning_index = ARGV.index('-wfree')
      @warning_free = !!warning_index ? ARGV[warning_index+1].to_i : 102400

      critical_index = ARGV.index('-cfree')
      @critical_free = !!critical_index ? ARGV[critical_index+1].to_i : 20480

    end

    def nagios_exit(exit_code, message, perf_stats)
      code_strings = [ "OK", "WARNING", "CRITICAL", "UNKNOWN", "DEPEDENT" ]
      puts "PASSENGER #{code_strings[exit_code]} - #{message}|#{perf_stats}"
      exit(exit_code)
    end

    def check_status
      garbage,metrics,values = `vmstat`.split("\n")
      # Strip white spaces
      metrics, values = [metrics, values].map{|row| row.strip}

      metrics = metrics.split(/\s+/)
      values = values.split(/\s+/)
      performance_stats = metrics.zip(values).map{|stat| "stat[0]=stat[1]"}

      nagios_exit(exit_code_for(metrics, values),[active,waiting].join(', '),[max,worker_count,active,inactive,waiting].join(';'))
    end

    def exit_code_for(max, active, waiting)
      if values[metrics.index('us')].to_i > @critical_cs or
         values[metrics.index('free')].to_i < @critical_free
        return 2
      end
      if values[metrics.index('us')].to_i > @warning_cs or
         values[metrics.index('free')].to_i < @warning_free or
        return 1
      end
      return 0
    end
  end
end

Nagios::Vmstat.new().check_status
