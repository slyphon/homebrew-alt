require 'formula'

class Vim < Formula
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :revision => '379a6398d462'
  version '7.3.353'
  homepage 'http://www.vim.org/'

  head 'https://vim.googlecode.com/hg/'

  def install
    # according to http://stackoverflow.com/q/8028410/965434
    # this *may* help stability
    ENV['ARCHS'] = 'i386'

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--with-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp",
                          "--with-ruby-command=/usr/bin/ruby",
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
