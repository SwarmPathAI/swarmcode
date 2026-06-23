class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.4"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.4/swarmcode-v0.5.4-darwin-universal.tar.gz"
  sha256 "b3c6f070bc4054d58904889cc6b255e7d3ccac1b4593ca17f66d30070d87a511"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
