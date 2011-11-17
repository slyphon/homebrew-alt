require 'formula'

class Ctags < Formula
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  homepage 'http://ctags.sourceforge.net/'
  md5 'c00f82ecdcc357434731913e5b48630d'

  head "git://github.com/lyosha/ctags-go.git"

  # true for both 5.8 and head
  fails_with_llvm "Resulting executable generates erroneous tag files", :build => 2335

  def install
    if ARGV.build_head?
      system "autoheader"
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make install"
  end
end
