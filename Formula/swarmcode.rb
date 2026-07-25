class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.12.2"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.12.2/swarmcode-v0.12.2-darwin-universal.tar.gz"
  sha256 "95e6b8a360e6e5afa43907f4d5d2f6abb79073a72af64a417f44f49040b341cb"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
