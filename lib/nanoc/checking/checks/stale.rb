# encoding: utf-8

module Nanoc::Checking::Checks

  class Stale < Nanoc::Checking::Check

    identifier :stale

    def run
      # FIXME re-enable this
      # The stale check is broken until the pruner is cleaned up
      # (merged into ItemRepWriter and put in core)
      return

      item_rep_paths = self.item_rep_paths

      self.output_filenames.each do |f|
        # FIXME re-enable pruner
#        next if self.pruner.filename_excluded?(f)
        if !item_rep_paths.include?(f)
          self.add_issue(
            "file without matching item",
            :subject  => f)
        end
      end
    end

  protected

    def item_rep_paths
      compiler = Nanoc::Compiler.new(@site)
      compiler.load
      compiler.build_reps
      compiler.item_rep_store.reps.
        flat_map { |r| r.paths_without_snapshot }.
        map { |r| File.join(@site.config[:output_dir], r) }
    end

    def pruner
      @pruner ||= begin
        exclude_config = @site.config.fetch(:prune, {}).fetch(:exclude, [])
        compiler = Nanoc::Compiler.new(self.site)
        identifier = compiler.item_rep_writer.class.identifier
        # FIXME re-enable pruner
        #pruner_class = Nanoc::Extra::Pruner.named(identifier)
        #pruner_class.new(@site, :exclude => exclude_config)
        # TODO implement
        nil
      end
    end

  end

end
