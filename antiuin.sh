#!/bin/bash
# ----------------------------------------------------------------------------------
# @name    : antiuin.sh
# @version : 0.1
# @date    : 29/12/2013 13:09:56
#
# TENTANG
# ----------------------------------------------------------------------------------
# Script untuk mengambil feed dan menampikan judul serta waktu posting artikel 
# terbaru di website AnTIuin (informatika.uin-malang.ac.id).
#
# CHANGELOG
# ----------------------------------------------------------------------------------
# versi 0.1 - 29/12/2013 13:09:56
#     - Rilis pertama.
#     - Working.. Bisa nampilkan judul dan tanggal posting artikel terbaru.
#     - Fitur verbose (tampilkan proses juga) atau quiet (tampilkan hasil aja).
#     - Fallback mode. Berguna ketika offline atau situs AnTIuin gagal diakses, akan
#       menampikan isi judul dan tanggal dari cache yg udah tersimpan sebelumnya.
#
# TODO
# ----------------------------------------------------------------------------------
#  - Opsi untuk membatasi jumlah judul yang ditampilkan.
#  - Trim judul yang panjang, biar rapi.
#  - Support conky.
#
# KONTAK
# ----------------------------------------------------------------------------------
# Ada bug? saran? sampaikan ke saya.
# Ghozy Arif Fajri / gojigeje
# email    : gojigeje@gmail.com
# web      : goji.web.id
# facebook : facebook.com/gojigeje
# twitter  : @gojigeje
# G+       : gplus.to/gojigeje
#
# LISENSI
# ----------------------------------------------------------------------------------
# Open Source tentunya :)
#  The MIT License (MIT)
#  Copyright (c) 2013 Ghozy Arif Fajri <gojigeje@gmail.com>

# ----------------------------------------------------------------------------------
# Tidak perlu mengubah setting/variabel apa-apa, cukup di-run saja :)
# ----------------------------------------------------------------------------------
setup() {
   VERSI="0.1 #29/12/2013"
   me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
   TMPDIR="$HOME/gojigeje"
   TMPFILE="$TMPDIR/.antiuin.tmp"
   READFILE="$TMPDIR/.antiuin.read"
   mkdir -p $TMPDIR
   touch $TMPFILE
}

cek_koneksi() {
   if eval "ping -c 1 8.8.4.4 -w 2 > /dev/null 2>&1"; then
      KONEK=true
      if eval "ping -c 1 informatika.uin-malang.ac.id -w 2 > /dev/null"; then
         KONEKUIN=true
      else
         KONEKUIN=false
      fi
   else
      KONEK=false
   fi
}

parsing() {
   curl -s http://informatika.uin-malang.ac.id/feed | grep -i '<title>\|pubdate' | tail -n+2 | sed -e 's/^[ \t]*//' | sed -e 's/<[^>]*>//g' > $TMPFILE
}

cekfile() {
   if [ -s "$TMPFILE" ]; then
      FILEOK=true
   else
      FILEOK=false
   fi
}

combine() {
   cat $TMPFILE | sed -n "1~2p" > "$TMPDIR/.antiuin.judul"
   cat $TMPFILE | sed -n "2~2p" > "$TMPDIR/.antiuin.tgl"
   JMLJUDUL=$(cat "$TMPDIR/.antiuin.judul" | wc -l)
   JMLTGL=$(cat $TMPDIR/.antiuin.tgl | wc -l)
   if [[ $JMLTGL = $JMLTGL ]]; then
      > "$TMPDIR/.antiuin.tgl.tmp"
      while read BARIS
      do
          echo "(${BARIS:6:5})" >> "$TMPDIR/.antiuin.tgl.tmp"
      done < "$TMPDIR/.antiuin.tgl"
      paste "$TMPDIR/.antiuin.judul" "$TMPDIR/.antiuin.tgl.tmp" | sed 's/\t/ /' > "$TMPDIR/antiuin.read.tmp"
      mv "$TMPDIR/antiuin.read.tmp" $READFILE
   else
      echo "gagal"
   fi
}

display_normal() {
   echo "------------------------------------------------------------------"
   echo -en "- Cek koneksi ke internet.."
   if $KONEK ; then
      echo "[OK]"
      echo -n "- Cek koneksi ke AnTIuin.."
      if $KONEKUIN; then
         echo "[OK]"
         echo -n "- Parsing feed dari http://informatika.uin-malang.ac.id/feed.."
         parsing
         cekfile
         if $FILEOK ; then
            echo "[OK]"
            combine
            echo "------------------------------------------------------------------"
            cat $READFILE
            echo "------------------------------------------------------------------"
         else
            if $FALLBACK ; then
               echo "[FAILED!]"
               echo "- Menampilkan feed yang lama.."
               echo "------------------------------------------------------------------"
               display_fallback
               echo "------------------------------------------------------------------"
            else
               echo "[FAILED!]"
               echo "- Pastikan situs AnTIuin bisa diakses!"
               exit
            fi
         fi
      else
         if $FALLBACK ; then
            echo "[FAILED!]"
            echo "- Menampilkan feed yang lama.."
            echo "------------------------------------------------------------------"
            display_fallback
            echo "------------------------------------------------------------------"
         else
            echo "[FAILED!]"
            echo "- ERROR - Pastikan situs AnTIuin bisa diakses!"
            exit
         fi
      fi
   else
      if $FALLBACK ; then
         echo "[FAILED!]"
         echo "- Menampilkan feed yang lama.."
         echo "------------------------------------------------------------------"
         display_fallback
         echo "------------------------------------------------------------------"
      else
         echo "[FAILED!]"
         echo "- ERROR - Pastikan komputer terhubung dengan internet!"
         exit
      fi
   fi
}

display_quiet() {
   if $KONEK ; then
      if $KONEKUIN; then
         parsing
         cekfile
         if $FILEOK ; then
            combine
            cat $READFILE
         else
            if $FALLBACK ; then
               display_fallback
            else
               exit
            fi
         fi
      else
         if $FALLBACK ; then
            display_fallback
         else
            exit
         fi
      fi
   else
      if $FALLBACK ; then
         display_fallback
      else
         exit
      fi
   fi
}

display_fallback() {
   cat $READFILE
}

fallback() {
   FALLBACK=true
}

version() {
   echo "  AnTIuin.sh"
   echo "  v $VERSI"
   echo "  Report bugs to Ghozy Arif Fajri <gojigeje@gmail.com>"
}

usage() {
   echo "------------------------------------------------------------------"
   version
   echo "------------------------------------------------------------------"
   echo ""
   echo "  Usage:       $me <action>"
   echo ""
   echo "  Action:      cek            Cek feed AnTIuin terbaru (verbose)"
   echo "               quiet | -q     Cek feed AnTIuin terbaru (quiet)"
   echo "               read | cache   Tampilkan feed lama (cache)"
   echo ""
}

cleanup() {
   rm "$TMPFILE" > /dev/null 2>&1
   rm "$TMPDIR/.antiuin.tgl" > /dev/null 2>&1
   rm "$TMPDIR/.antiuin.judul" > /dev/null 2>&1
   rm "$TMPDIR/.antiuin.tgl.tmp" > /dev/null 2>&1
}

setup
case "$1" in
   "cek"|"-c" )
      cek_koneksi
      display_normal
      cleanup
   ;;
   "conky"|"-q"|"quiet" )
      fallback
      cek_koneksi
      display_quiet
      cleanup 
   ;;
   "read"|"cache" )
      display_fallback
   ;;
   *)
      usage
   ;;
esac

# :)