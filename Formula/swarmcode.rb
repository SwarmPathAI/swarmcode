class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.9.1"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.9.1/swarmcode-v0.9.1-darwin-universal.tar.gz"
  sha256 "6ed6915d337b9137a4d8218bd01342382b82facb57afeb8508db380b27d83a66"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
