{ lib, ... }:
let
  handles = app: mimes: lib.genAttrs mimes (_: app);
  okular = suffix: handles "okularApplication_${suffix}.desktop";
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications =
      handles "org.kde.dolphin.desktop" [ "inode/directory" ]
      // handles "org.kde.kate.desktop" [
        "text/plain"
        "text/markdown"
        "text/csv"
        "text/x-log"
        "text/x-nix"
        "text/x-python"
        "text/x-csrc"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-shellscript"
        "text/x-tex"
        "text/vcard"
        "application/json"
        "application/xml"
        "text/xml"
        "application/x-yaml"
        "application/toml"
        "application/x-desktop"
        "application/javascript"
        "application/x-shellscript"
      ]

      // handles "org.kde.gwenview.desktop" [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/x-webp"
        "image/bmp"
        "image/tiff"
        "image/avif"
        "image/heif"
        "image/jxl"
        "image/svg+xml"
        "image/svg+xml-compressed"
        "image/openraster"
        "image/x-icns"
        "image/x-ico"
        "image/x-psd"
        "image/x-tga"
        "image/x-xcf"
        "image/x-xbitmap"
        "image/x-xpixmap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
      ]

      // handles "org.kde.ark.desktop" [
        "application/zip"
        "application/gzip"
        "application/zstd"
        "application/vnd.rar"
        "application/arj"
        "application/x-7z-compressed"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/x-bzip"
        "application/x-bzip2"
        "application/x-bzip-compressed-tar"
        "application/x-bzip2-compressed-tar"
        "application/x-xz"
        "application/x-xz-compressed-tar"
        "application/x-lzma"
        "application/x-lzma-compressed-tar"
        "application/x-lzip"
        "application/x-lzip-compressed-tar"
        "application/x-lz4"
        "application/x-lz4-compressed-tar"
        "application/x-lrzip"
        "application/x-lrzip-compressed-tar"
        "application/x-lzop"
        "application/x-tarz"
        "application/x-tzo"
        "application/x-archive"
        "application/x-cpio"
        "application/x-java-archive"
        "application/x-rpm"
        "application/x-source-rpm"
        "application/x-lha"
        "application/x-stuffit"
        "application/x-xar"
        "application/x-cd-image"
        "application/vnd.debian.binary-package"
        "application/vnd.ms-cab-compressed"
        "application/vnd.efi.iso"
      ]

      // okular "pdf" [
        "application/pdf"
        "application/x-gzpdf"
        "application/x-bzpdf"
        "application/x-wwf"
      ]
      // okular "epub" [ "application/epub+zip" ]
      // okular "mobi" [ "application/x-mobipocket-ebook" ]
      // okular "djvu" [ "image/vnd.djvu" ]
      // okular "fb" [ "application/x-fictionbook+xml" ]
      // okular "comicbook" [
        "application/x-cbz"
        "application/x-cbr"
        "application/x-cbt"
        "application/x-cb7"
      ]
      // okular "xps" [
        "application/oxps"
        "application/vnd.ms-xpsdocument"
      ]
      // okular "dvi" [
        "application/x-dvi"
        "application/x-gzdvi"
        "application/x-bzdvi"
      ]
      // okular "ghostview" [
        "application/postscript"
        "application/x-gzpostscript"
        "application/x-bzpostscript"
        "image/x-eps"
        "image/x-gzeps"
        "image/x-bzeps"
      ]

      // handles "org.kde.dragonplayer.desktop" [
        "video/mp4"
        "video/mpeg"
        "video/webm"
        "video/avi"
        "video/quicktime"
        "video/x-matroska"
        "video/x-msvideo"
        "video/x-ms-asf"
        "video/x-ms-wmv"
        "video/x-flv"
        "video/x-flic"
        "video/x-ogm+ogg"
        "video/x-theora+ogg"
        "video/vnd.rn-realvideo"
        "video/ogg"
      ]

      // handles "org.kde.elisa.desktop" [
        "audio/mpeg"
        "audio/mp4"
        "audio/ogg"
        "audio/aac"
        "audio/flac"
        "audio/x-flac"
        "audio/x-flac+ogg"
        "audio/x-mp3"
        "audio/x-wav"
        "audio/vorbis"
        "audio/x-vorbis"
        "audio/x-vorbis+ogg"
        "audio/x-opus+ogg"
        "audio/x-speex+ogg"
        "audio/x-musepack"
        "audio/x-ms-wma"
        "audio/mpegurl"
        "audio/x-mpegurl"
        "audio/x-scpls"
        "audio/vnd.rn-realaudio"
        "audio/x-pn-realaudio"
      ]

      // handles "firefox.desktop" [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
  };
}
