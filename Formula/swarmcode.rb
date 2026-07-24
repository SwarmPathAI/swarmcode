class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.12.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.12.0/swarmcode-v0.12.0-darwin-universal.tar.gz"
  sha256 "08eafccc5c3a19d03c4a2985ec37f94bd526962a22e0ed68df01522f748ba00a"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
