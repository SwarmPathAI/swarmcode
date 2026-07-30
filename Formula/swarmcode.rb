class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.14.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.14.0/swarmcode-v0.14.0-darwin-universal.tar.gz"
  sha256 "fe35d1afde036ea6a445436a08417abdb16dd6900578515c47e023f99271a995"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
