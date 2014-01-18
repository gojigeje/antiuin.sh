antiuin.sh
==========

Simple bash script for fetch and display feed from [informatika.uin-malang.ac.id](http://informatika.uin-malang.ac.id) (title and publish date)

#### USAGE

Make executable and run:

```bash
$ ./antiuin.sh 
------------------------------------------------------------------
  AnTIuin.sh
  v 0.2 #08/01/2014
  Report bugs to Ghozy Arif Fajri <gojigeje@gmail.com>
------------------------------------------------------------------

  Usage:       antiuin.sh <action> <limit>

  Action:      cek            Cek feed AnTIuin terbaru (verbose)
               quiet | -q     Cek feed AnTIuin terbaru (quiet)
               read | cache   Tampilkan feed lama (cache)

  Limit:       1-5            Jumlah feed yang ditampilkan

# Verbose mode and limit number of displayed feed to 2
$ ./antiuin.sh cek 2
------------------------------------------------------------------
- Cek koneksi ke internet..[OK]
- Cek koneksi ke AnTIuin..[OK]
- Parsing feed dari http://informatika.uin-malang.ac.id/feed..[OK]
------------------------------------------------------------------
Pendaftaran Ujian KOMPRE _Januari 2014 (7 Jan)
Revisi_Data PEMBIMBING Skripsi_Ujian Sempro Oktober 2013 (6 Dec)
------------------------------------------------------------------

# Quiet mode and limit number of displayed feed to 3
$ ./antiuin.sh -q 3
Pendaftaran Ujian KOMPRE _Januari 2014 (7 Jan)
Revisi_Data PEMBIMBING Skripsi_Ujian Sempro Oktober 2013 (6 Dec)
(revisi)Jadwal UAS Jurusan Teknik Informatika Ganjil TA. 2013/2014 (2 Dec)

```