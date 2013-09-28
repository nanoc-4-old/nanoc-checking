# encoding: utf-8

module Nanoc
  module Checking
    module Checks
    end
  end
end

# version
require 'nanoc/checking/version'

# main
require 'nanoc/checking/check'
require 'nanoc/checking/dsl'
require 'nanoc/checking/runner'
require 'nanoc/checking/issue'

# helper
require 'nanoc/checking/helper/link_collector'

# checks
require 'nanoc/checking/checks/css'
require 'nanoc/checking/checks/external_links'
require 'nanoc/checking/checks/html'
require 'nanoc/checking/checks/internal_links'
require 'nanoc/checking/checks/stale'

# cli integration
require 'nanoc/checking/cli'
