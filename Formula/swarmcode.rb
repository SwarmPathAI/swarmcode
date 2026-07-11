class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.7.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.7.0/swarmcode-v0.7.0-darwin-universal.tar.gz"
  sha256 "fe90d41835761ba9193f013079888f20fe37d5cf6bc616080a7afe0066fb10fd"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
