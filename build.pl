#!/usr/bin/perl

use strict;
use warnings;

use Template;
use File::Find;
use File::Copy::Recursive qw(dircopy);
use File::Path qw(remove_tree);

my $vars = {
  screen_width => 1280,
  screen_height => 720,

  #active_selected_button_bgcolor => "#8fa4c2",
  active_selected_button_bgcolor => "#38527a",
  inactive_selected_button_bgcolor => "#666666",
  unselected_button_bgcolor => "#000000",

  active_unselected_selector_bgcolor => "#111111",

  foreground_text_color => "#aaaaaa",
  background_text_color => "#aaaaaa",
  warning_text_color => "#cccc00",
  #selected_text_color => "#000000",
  active_selected_text_color => "#dddddd",
  inactive_selected_text_color => "#000000",

  dialog_bgcolor => "#222222",
  dialog_border_color => "#38527a",
  dialog_border_size => 1,

  progress_color => "#38527a",
  progress_bgcolor => "#444444",

  menu_font_pixelsize => 50,
  h1_font_pixelsize => 24,
  h1_field_pixelsize => 34,
  h2_font_pixelsize => 22,
  recording_icon_font_pixelsize => 12,

  recording_icon_height => 20,
  recording_icon_width => 90,

  button_spacing => 5,

  line_width => 2,
  line_color => "#aaaaaa",

  separator_color => "#333333",

  guide_height => 396,
  guide_channels => 6,
  guide_timeslots => 6,
  guide_recording_color => "#224a2b",
  guide_error_color => "#7a0000",

  status_normal_bgcolor => "#38527a",
  status_disabled_bgcolor => "#666666",
  status_running_bgcolor => "#224a2b",
  status_error_bgcolor => "#7a0000",
  status_warning_bgcolor => "#aaaa00",
  status_normal_text_color => "#dddddd",
  status_disabled_text_color => "#000000",
  status_running_text_color => "#dddddd",
  status_error_text_color => "#dddddd",
  status_warning_text_color => "#000000",

  video_tree_button_spacing => 5,
  video_browser_button_spacing => 5,

  checkbox_size => 16,

  base_button_width => 150,
};


$vars->{footer_height} = $vars->{h1_font_pixelsize} + 18 + $vars->{line_width};
$vars->{body_height} = $vars->{screen_height} - 10 - $vars->{footer_height};
$vars->{num_buttons} = int(($vars->{body_height} - 20 ) / ($vars->{h1_field_pixelsize} + $vars->{button_spacing}));
$vars->{recordings_button_spacing} = int(($vars->{body_height} - 20 - ($vars->{num_buttons} * $vars->{h1_field_pixelsize})) / $vars->{num_buttons});
$vars->{footer_y} = 10 + $vars->{body_height};

$vars->{dialog_header_height} = 10 + $vars->{h1_field_pixelsize} + 2 + $vars->{line_width};

$vars->{base_button_height} = 2 + $vars->{h1_field_pixelsize};


my $src= "src";
my $dist = "corner_case";

my $tt = Template->new(
  RELATIVE => 1,
  INCLUDE_PATH => ".:$src"
) or die $Template::ERROR;

remove_tree($dist);

find({ wanted => \&process_template, no_chdir => 1}, $src);

sub process_template {
  my $file_path = $File::Find::name;
  my $out_path = $File::Find::name;
  $out_path =~ s/^$src/$dist/;
  if ($file_path =~ /\.xml$/ or $file_path =~ /\.html$/ or $file_path =~ /qtlook.txt$/) {
    $tt->process("$file_path", $vars, "$out_path") or die $tt->error();
  }
}

dircopy("$src/images", "$dist/images")
