class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.9.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.9.0/swarmcode-v0.9.0-darwin-universal.tar.gz"
  sha256 "845955e5de53444196566ed5253d95efb06abb43c2c566fb452d6e2c91aff78f"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
