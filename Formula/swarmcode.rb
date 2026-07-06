class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.6.3"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.6.3/swarmcode-v0.6.3-darwin-universal.tar.gz"
  sha256 "efdcfa52d222c324202481fb5d804b4cfba3b92c5a2f12838662c32724a45456"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
