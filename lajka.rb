#!/usr/bin/env ruby

require "rubygems"
require "commander/import"

program :version, "0.0.1"
program :description, "Command-line tool for copying photographs from somewhere to elsewhere."
default_command :copy

jpeg_extensions = %[.jpg .jpeg .jpe .jif .jfif .jfi]
raw_extensions = %[.3fr .ari .arw .bay .crw .cr2 .cap .dcs .dcr .dng .drf .eip .erf .fff .iiq .k25 .kdc .mdc .mef .mos .mrw .nef .nrw .obm .orf .pef .ptx .pxn .r3d .raf .raw .rwl .rw2 .rwz .sr2 .srf .srw .x3f]
video_extensions = %[.avi .mpeg .mpg .mp4 .mov .3gp .mkv]

command :copy do |c|
  c.syntax = "lajka run <source> <destination>"
  c.description = "Copies photographs from somewhere to elsewhere"
  c.action do |args, options|
    source_arg = "#{args.shift}/**/*" || abort("source argument required.")
    destination_arg = args.shift || abort("destination argument required.")

    Dir.glob(source_arg).each do |file|
      exit unless File.file? file

      name = File.basename file
      ext = File.extname(file).downcase
      date = File.mtime file
      type = "MISC"
      type = "JPEG" if jpeg_extensions.include? ext
      type = "RAW" if raw_extensions.include? ext
      type = "VIDEO" if video_extensions.include? ext

      destination = "#{destination_arg}/#{type}/#{date.year}/#{date.strftime('%F')}"

      FileUtils.mkdir_p destination unless File.directory? destination

      unless File.file? "#{destination}/#{name}"
        FileUtils.cp file, destination, preserve: true
        puts "Copied #{name} [#{date.strftime('%F')}] [#{type}]"
      else
        puts "Ignored #{name} (exists) [#{date.strftime('%F')}] [#{type}]"
      end
    end
  end
end
