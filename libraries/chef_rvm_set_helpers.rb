class Chef
  module RVM
    module SetHelpers
      def rvm_do(user = nil)
        # Use Gem's version comparing code to compare the two strings
        if Gem::Version.new(VersionCache.fetch_version(user)) < Gem::Version.new("1.8.6")
          "exec"
        else
          "do"
        end
      end

    end
  end
end
