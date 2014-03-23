# encoding: utf-8

module Nanoc::Checking::Checks

  class Stale < Nanoc::Checking::Check

    identifier :stale

    def run
      item_rep_paths = self.item_rep_paths

      self.build_filenames.each do |f|
        # FIXME filename_excluded? is part of filesystem pruner only
        next if self.pruner.filename_excluded?(f)
        if !item_rep_paths.include?(f)
          self.add_issue(
            "file without matching item",
            :subject  => f)
        end
      end
    end

  protected

    def compiler
      @_compiler ||= Nanoc::CompilerBuilder.new.build(@site)
    end

    def item_rep_paths
      compiler.item_rep_store.reps.
        flat_map { |r| r.written_paths }.
        map { |r| File.join(@site.config[:build_dir], r) }
    end

    def pruner
      @pruner ||= begin
        exclude_config = @site.config.fetch(:prune, {}).fetch(:exclude, [])
        identifier = compiler.item_rep_writer.class.identifier
        pruner_class = Nanoc::Pruner.named(identifier)
        pruner_class.new(@site, :exclude => exclude_config)
      end
    end

  end

end
