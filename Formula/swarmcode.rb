class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.1"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.1/swarmcode-v0.5.1-darwin-universal.tar.gz"
  sha256 "5193f1099348006c58f62eeb6a11e73d97510333e1abfc358494286766a7afe9"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
