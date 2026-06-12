class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.0/swarmcode-v0.5.0-darwin-universal.tar.gz"
  sha256 "633259e1acc55c54c298ffc26c3c2eb2c53296eb4932214da5bc1b48e71ad687"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
