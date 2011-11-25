require 'formula'

class Weechat < Formula
  head 'git://git.sv.gnu.org/weechat.git'
  url 'http://www.weechat.org/files/src/weechat-0.3.6.tar.bz2'
  homepage 'http://www.weechat.org'
  sha256 '6c367e36fb76de318410f0bc5f2043056155ffe1372c121c1f90520b4645a27e'

  depends_on 'gnutls'

  def patches
    DATA
  end

  def install
    # I don't give a crap about perl...
    standalone_ruby = File.join(HOMEBREW_CELLAR, 'ruby', '1.9.2-p290')
    autoconf = File.join(HOMEBREW_CELLAR, 'autoconf/2.68/bin/autoconf')

    unless File.exists?(standalone_ruby)
      raise "could not find the homebrew ruby-1.9.2-p290 install at #{standalone_ruby}"
    end

    unless File.exists?(autoconf)
      raise "could not find updated homebrew autoconf 2.68 at #{autoconf}"
    end

    archs = ['-arch x86_64']

    system autoconf

    system "./configure",
      "--disable-perl",
      "--disable-python",
      "--disable-lua",
      "--disable-tcl",
      "--prefix=#{prefix}",
#       "--disable-gnutls",
      "--disable-aspell",
      "--with-debug",
      "--with-ruby",
      "RUBY=#{standalone_ruby}/bin/ruby",
      "LDFLAGS=-L#{standalone_ruby}/lib"

    system "make install"
  end
end

__END__
--- ./src/core/wee-hook.h.orig  2011-11-25 02:30:03.000000000 +0000
+++ ./src/core/wee-hook.h       2011-11-25 02:30:23.000000000 +0000
@@ -19,6 +19,7 @@
 
 #ifndef __WEECHAT_HOOK_H
 #define __WEECHAT_HOOK_H 1
+#include <unistd.h>
 
 #ifdef HAVE_GNUTLS
 #include <gnutls/gnutls.h>

