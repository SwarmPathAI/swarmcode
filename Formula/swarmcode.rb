class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.12.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.12.0/swarmcode-v0.12.0-darwin-universal.tar.gz"
  sha256 "e3285665e4d3bb99ce57203f4aa976de8ca2718e55772d7fe87ad46474286104"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
