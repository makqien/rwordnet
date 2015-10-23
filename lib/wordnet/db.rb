require 'stringio'

module WordNet
  # Represents the WordNet database, and provides some basic interaction.
  class DB
    # By default, use the bundled WordNet
    @path = File.expand_path("../../../WordNet-3.0/", __FILE__)

    class << self; attr_accessor :cached end
    @cached = false
    @raw_wordnet = {}


    class << self
      # To use your own WordNet installation (rather than the one bundled with rwordnet:
      # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
      attr_accessor :path

      # Open a wordnet database. You shouldn't have to call this directly; it's
      # handled by the autocaching implemented in lemma.rb.
      #
      # `path` should be a string containing the absolute path to the root of a
      # WordNet installation.
      def open(path, &block)
        if not @cached
            File.open(File.join(self.path, path), "r", &block)
        else
            self.open_with_cache(path, &block)
        end

      end

      def open_with_cache(path, &block)
        path = File.join(self.path, path)
        if not @raw_wordnet.has_key? path
            @raw_wordnet[path] = StringIO.new File.open(path).read
        end
        fp = @raw_wordnet[path]
        if not block
            fp
        else
            yield fp
        end
      end
    end
  end
end
