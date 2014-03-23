# encoding: utf-8

module Nanoc::Checking::Checks

  class CSS < Nanoc::Checking::Check

    identifier :css

    def run
      require 'w3c_validators'

      Dir[site.config[:build_dir] + '/**/*.css'].each do |filename|
        results = ::W3CValidators::CSSValidator.new.validate_file(filename)
        results.errors.each do |e|
          desc = e.message.gsub(%r{\s+}, ' ').strip
          self.add_issue(desc, :subject => filename)
        end
      end
    end

  end

end
