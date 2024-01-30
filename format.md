# BDFpixel format

BDFpixel is a data format for 

BDFpixel extends the Adobe Glyph [Bitmap Distribution Format][bdf] by
providing an additional "WYSIWYG" bitmap format and and making some
pieces of data optional if they can be computed.

Every BDF file is also a valid BDFpixel file.

[bdf]: https://adobe-type-tools.github.io/font-tech-notes/pdfs/5005.BDF_Spec.pdf

## BITMAP

"WYSIWYG" pixel data is the most important benefit of PIXELbdf.

Instead of supplying hexadecimal data, you can supply each row as a
start marker followed by a string of pixels and an optional end
marker.

A start marker is the character `|`, `+`, or `^`.

-   `|` is the start marker for most rows of pixels.

-   `+` indicates the position of the baseline.  It is used to
    determine the offset of the `BBX`.
    
    If no baseline is indicated with a `+`, the last row of pixels
    becomes the baseline.

-   `^` indicates the cap height.  It is not checked as there is no
    provision in BDF for specifying the cap height anyway.  (The XLFD
    extensions to BDF do specify a capital height.)
    
    This provision is provided as a convenience for font authors.

Following that are the pixels.  A space, full stop, or zero specifies
an off pixel.  Any other character (except for a start marker)
specifies an on pixel.

If an additional end marker is specified, it terminates the row of
pixels.  The end marker can be `|`, `+`, or `^`, but it is not
checked.

If no end marker is specified, the last non-space character terminates
the pixel row.

If the glyph pixel data is supplied in this form, the `BITMAP` keyword
is optional.

Examples:

    STARTCHAR U+0045 LATIN CAPITAL LETTER E
    ...
    BITMAP
    | ##### |
    | #     |
    | #     |
    | ####  |
    | #     |
    | #     |
    + ##### +
    |       |
    ENDCHAR
    STARTCHAR U+0046 LATIN CAPITAL LETTER F
    ...

    U+0045 LATIN CAPITAL LETTER E
    ...
    | #####
    | #
    | #
    | #### 
    | #
    | #
    | #####
    U+0046 LATIN CAPITAL LETTER F
    ...

## CHARS

The `CHARS` keyword indicating the start of the glyph data section is
optional.  A `STARTCHAR` keyword also has the additional purpose of
starting the glyph data section.

If the `CHARS` keyword is specified, the number of glyphs specified
with it is optional.

## STARTCHAR

The keyword `STARTCHAR` may also be followed by a Unicode hexadecimal
codepoint specified as `U+1F4A9` or `0x1f4a9`.  The codepoint may be
followed by any additional text.

If the hexadecimal codepoint is specified in either of the above
forms, the word `STARTCHAR` can be omitted and the line can start with
`U+1F4A9` or `0x1F4a9`.

    STARTCHAR U+1F4A9 PILE OF POO

## ENCODING

If the `STARTCHAR` keyword is followed by a hexadecimal codepoint as
specified above, the `ENCODING` line is optional.

## BBX

If the `BITMAP` data is supplied as "WYSIWYG" pixel data as specified
above, the `BBX` is optional as it can be computed, with the _x_
offset always being zero.

## ENDCHAR

The `ENDCHAR` keyword is optional; a `STARTCHAR`, `ENDFONT`, or end of
file terminates the glyph's data.

## ENDFONT

The `ENDFONT` keyword is optional; without it, the end of the file is
also the end of the font.
