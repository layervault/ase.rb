<?php 
    /** 
    * Make an Adobe Swatch Exchange file 
    * 
    * @param    array 
    * @return   string 
    * @see      http://www.colourlovers.com/web/blog/2007/11/08/color-palettes-in-adobe-swatch-exchange-ase 
    * @author   Chris Williams - http://www.colourlovers.com 
    * @version  2.0 
    * This script uses the Multibyte String extension: http://www.php.net/manual/en/book.mbstring.php 
    * MIT License 
    * Copyright (c) 2011 Chris Williams - http://www.colourlovers.com 
    * Permission is hereby granted, free of charge, to any person obtaining a copy 
    * of this software and associated documentation files (the "Software"), to deal 
    * in the Software without restriction, including without limitation the rights 
    * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
    * copies of the Software, and to permit persons to whom the Software is 
    * furnished to do so, subject to the following conditions: 
    * The above copyright notice and this permission notice shall be included in 
    * all copies or substantial portions of the Software. 
    * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
    * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
    * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
    * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
    * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
    * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
    * THE SOFTWARE. 
    */ 
    function mkASE($palettes) { 
        $internal_encoding = mb_internal_encoding(); 
        mb_internal_encoding("UTF-8"); 

        ob_start(); 

        $totalColors = $numPalettes = 0; 

        foreach ($palettes as $palette) { 
            $totalColors += count($palette["colors"]); 
            ++$numPalettes; 
        } 

        echo "ASEF"; # File signature 
        echo pack("n*",1,0); # Version 
        echo pack("N",$totalColors + ($numPalettes * 2)); # Total number of blocks 

        foreach ($palettes as $palette) { 
            echo pack("n",0xC001); # Group start 

            # Length of this block - see below 

            $title  = (mb_convert_encoding($palette["title"],"UTF-16BE","UTF-8") . pack("n",0)); 
            $buffer = pack("n",(strlen($title) / 2)); # Length of the group title 
            $buffer .= $title; # Group title 

            echo pack("N",strlen($buffer)); # Length of this block 
            echo $buffer; 

            foreach ($palette["colors"] as $color) { 
                echo pack("n",1); # Color entry 

                # Length of this block - see below 

                $title  = (mb_convert_encoding($color[1],"UTF-16BE","UTF-8") . pack("n",0)); 
                $buffer = pack("n",(strlen($title) / 2)); # Length of the title 
                $buffer .= $title; # Title 

                # Colors 
                list ($r,$g,$b) = array_map("intval",sscanf($color[0],"%2x%2x%2x")); 
                $r /= 255; 
                $g /= 255; 
                $b /= 255; 

                $buffer .= "RGB "; 
                $buffer .= strrev(pack("f",$r)); 
                $buffer .= strrev(pack("f",$g)); 
                $buffer .= strrev(pack("f",$b)); 
                $buffer .= pack("n",0); # Color type - 0x00 "Global" 

                echo pack("N",strlen($buffer)); # Length of this block 
                echo $buffer; 
            } 
            echo pack("n",0xC002); # Group end 

            echo pack("N",0); # Length of "Group end" block, which is 0 
        } 

        $return = ob_get_contents(); 
        ob_end_clean(); 

        mb_internal_encoding($internal_encoding); 

        return $return; 
    } 

/* 
    Colors from the Palettes: 
        Vintage Modern        http://www.colourlovers.com/palette/110225/Vintage_Modern 
        Thought Provoking     http://www.colourlovers.com/palette/694737/Thought_Provoking 

    Licensed under Creative Commons: http://creativecommons.org/licenses/by-nc-sa/3.0/ 
*/ 

    $palettes = array ( 
        array ( 
            "title"     => "Simple", 
            "colors"    => array ( 
                array ("FFFFFF","White"), 
                array ("000000","Black"), 
            ), 
        ),
    ); 

    $ase = mkASE($palettes);
    file_put_contents('./control.ase', $ase);