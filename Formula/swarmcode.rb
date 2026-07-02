class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.6.1"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.6.1/swarmcode-v0.6.1-darwin-universal.tar.gz"
  sha256 "257cf1a1983a55c3884c2041f99a0a915953eca00bd7db5ce4e1760e8862ceda"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
