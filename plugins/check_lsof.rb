#!/usr/bin/env ruby
module Nagios
  class Vmstat

    def initialize
    end

    def nagios_exit(exit_code, message, perf_stats)
      code_strings = [ "OK", "WARNING", "CRITICAL", "UNKNOWN", "DEPEDENT" ]
      puts "LSOF #{code_strings[exit_code]} - #{message}|#{perf_stats}"
      exit(exit_code)
    end

    def check_status
      open_descriptors = `sudo lsof | wc -l`.split("\n")[0]

      nagios_exit(0, "open=#{open_descriptors}", "open=#{open_descriptors}")
    end

    # Unused as of now, keeping this for future use
    def exit_code_for(metrics, values)
      if values[metrics.index('us')].to_i > @critical_us or
         values[metrics.index('free')].to_i < @critical_free
        return 2
      end
      if values[metrics.index('us')].to_i > @warning_us or
         values[metrics.index('free')].to_i < @warning_free
        return 1
      end
      return 0
    end
  end
end

Nagios::Vmstat.new().check_status
