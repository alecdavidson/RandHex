#!/usr/bin/env ruby

class RandColor

  require 'clipboard'
  require 'green_shoes'
  require 'colormath'

  def self.rand_hex
    hex = Array.new(6)

    (0..5).each { |i|
      hex[i] = Random.rand(16).to_s(16).capitalize
    }

    return "##{hex.join()}"
  end

  def self.find_rev(color)
    the_color = ColorMath::hex_color(color)
    the_hue = the_color.hue + 180

    while the_hue > 360
      the_hue -= 360
    end

    rev = ColorMath::HSL.new(the_hue, the_color.saturation + 50, the_color.luminance)

    rev = rev.hex

    (0..6).each { |i|
      rev[i] = rev[i].capitalize }

    return rev
  end
  
  def display_color

    Shoes.app title: 'Random Color',
     width: 500, height: 300 do
      backcolor = RandColor.rand_hex
      background backcolor
	    revcolor = RandColor.find_rev(backcolor)
      @color = stack { para backcolor, align: 'center', size: 70, stroke: revcolor
					             para 'Text color: ' + revcolor, align: 'center', size: 15, stroke: revcolor
                       para 'Click text to recolor', align: 'center', size: 25, stroke: revcolor }
	  
      @copy = stack {  para 'Click here to copy color', align: 'center', size: 25, stroke: revcolor }
	    @copy2 = stack { para 'Click here to copy text color', align: 'center', size: 15, stroke: revcolor }

      @color.click{
        backcolor = RandColor.rand_hex
        background backcolor
		    revcolor = RandColor.find_rev(backcolor)
        @color.clear { para backcolor, align: 'center', size: 70, stroke: revcolor
                       para 'Text color: ' + revcolor, align: 'center', size: 15, stroke: revcolor
                       para 'Click text to recolor', align: 'center', size: 25, stroke: revcolor }
		    @copy.clear {  para 'Click here to copy color', align: 'center', size: 25, stroke: revcolor }
		    @copy2.clear { para 'Click here to copy text color', align: 'center', size: 15, stroke: revcolor }
      }

      @copy.click{
        Clipboard.copy backcolor + ' ' + revcolor
        alert(backcolor + ' copied to clipboard!') }
	    @copy2.click{
        Clipboard.copy revcolor
        alert(revcolor + ' copied to clipboard!') }
    end
  end
end


if __FILE__ == $0
  RC = RandColor.new
  RC.display_color
end