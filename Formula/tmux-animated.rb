class TmuxAnimated < Formula
  desc "tmux with smooth animations for window switches and pane operations"
  homepage "https://github.com/jonaburg/tmux-animated"
  url "https://github.com/jonaburg/tmux-animated.git",
      branch: "animations"
  version "next-3.7.0"
  license "ISC"

  head "https://github.com/jonaburg/tmux-animated.git", branch: "animations"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  def install
    system "./autogen.sh"
    system "./configure",
           "--disable-debug",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--sysconfdir=#{etc}",
           "--enable-utf8proc",
           "--program-suffix=-animated"
    system "make", "install"

    # tmux's Makefile installs the man page with a hard-coded name; rename
    # so it doesn't collide with a parallel `tmux` formula's man page.
    mv man1/"tmux.1", man1/"tmux-animated.1" if (man1/"tmux.1").exist?
  end

  test do
    output = shell_output("#{bin}/tmux-animated -V")
    assert_match "tmux", output
  end
end
