class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.8.1"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.8.1/swarmcode-v0.8.1-darwin-universal.tar.gz"
  sha256 "69b6235154a1cacccc18b09200524c137fc27cfa107cbdee59d816e8f62a2135"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
