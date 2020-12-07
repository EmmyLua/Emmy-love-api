---@class love.image
---Provides an interface to decode encoded image data.
local m = {}

--region CompressedImageData
---@class CompressedImageData
---Represents compressed image data designed to stay compressed in RAM.
---
---CompressedImageData encompasses standard compressed texture formats such as  DXT1, DXT5, and BC5 / 3Dc.
---
---You can't draw CompressedImageData directly to the screen. See Image for that.
local CompressedImageData = {}
---Gets the width and height of the CompressedImageData.
---@return number, number
---@overload fun(level:number):number, number
function CompressedImageData:getDimensions() end

---Gets the format of the CompressedImageData.
---@return CompressedImageFormat
function CompressedImageData:getFormat() end

---Gets the height of the CompressedImageData.
---@return number
---@overload fun(level:number):number
function CompressedImageData:getHeight() end

---Gets the number of mipmap levels in the CompressedImageData. The base mipmap level (original image) is included in the count.
---@return number
function CompressedImageData:getMipmapCount() end

---Gets the width of the CompressedImageData.
---@return number
---@overload fun(level:number):number
function CompressedImageData:getWidth() end

--endregion CompressedImageData
--region ImageData
---@class ImageData
---Raw (decoded) image data.
---
---You can't draw ImageData directly to screen. See Image for that.
local ImageData = {}
---Encodes the ImageData and optionally writes it to the save directory.
---@param format ImageFormat @The format to encode the image as.
---@param filename string @The filename to write the file to. If nil, no file will be written but the FileData will still be returned.
---@return FileData
---@overload fun(outFile:string):void
---@overload fun(outFile:string, format:ImageFormat):void
function ImageData:encode(format, filename) end

---Gets the width and height of the ImageData in pixels.
---@return number, number
function ImageData:getDimensions() end

---Gets the height of the ImageData in pixels.
---@return number
function ImageData:getHeight() end

---Gets the color of a pixel at a specific position in the image.
---
---Valid x and y values start at 0 and go up to image width and height minus 1. Non-integer values are floored.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---@param x number @The position of the pixel on the x-axis.
---@param y number @The position of the pixel on the y-axis.
---@return number, number, number, number
function ImageData:getPixel(x, y) end

---Gets the width of the ImageData in pixels.
---@return number
function ImageData:getWidth() end

---Transform an image by applying a function to every pixel.
---
---This function is a higher-order function. It takes another function as a parameter, and calls it once for each pixel in the ImageData.
---
---The passed function is called with six parameters for each pixel in turn. The parameters are numbers that represent the x and y coordinates of the pixel and its red, green, blue and alpha values. The function should return the new red, green, blue, and alpha values for that pixel.
---
---function pixelFunction(x, y, r, g, b, a)
---
---    -- template for defining your own pixel mapping function
---
---    -- perform computations giving the new values for r, g, b and a
---
---    -- ...
---
---    return r, g, b, a
---
---end
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---@param pixelFunction function @Function to apply to every pixel.
---@param x number @The x-axis of the top-left corner of the area within the ImageData to apply the function to.
---@param y number @The y-axis of the top-left corner of the area within the ImageData to apply the function to.
---@param width number @The width of the area within the ImageData to apply the function to.
---@param height number @The height of the area within the ImageData to apply the function to.
function ImageData:mapPixel(pixelFunction, x, y, width, height) end

---Paste into ImageData from another source ImageData.
---@param source ImageData @Source ImageData from which to copy.
---@param dx number @Destination top-left position on x-axis.
---@param dy number @Destination top-left position on y-axis.
---@param sx number @Source top-left position on x-axis.
---@param sy number @Source top-left position on y-axis.
---@param sw number @Source width.
---@param sh number @Source height.
function ImageData:paste(source, dx, dy, sx, sy, sw, sh) end

---Sets the color of a pixel at a specific position in the image.
---
---Valid x and y values start at 0 and go up to image width and height minus 1.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---@param x number @The position of the pixel on the x-axis.
---@param y number @The position of the pixel on the y-axis.
---@param r number @The red component (0-1).
---@param g number @The green component (0-1).
---@param b number @The blue component (0-1).
---@param a number @The alpha component (0-1).
function ImageData:setPixel(x, y, r, g, b, a) end

--endregion ImageData
---Compressed image data formats. Here and here are a couple overviews of many of the formats.
---
---Unlike traditional PNG or jpeg, these formats stay compressed in RAM and in the graphics card's VRAM. This is good for saving memory space as well as improving performance, since the graphics card will be able to keep more of the image's pixels in its fast-access cache when drawing it.
CompressedImageFormat = {
	---The DXT1 format. RGB data at 4 bits per pixel (compared to 32 bits for ImageData and regular Images.) Suitable for fully opaque images on desktop systems.
	['DXT1'] = 1,
	---The DXT3 format. RGBA data at 8 bits per pixel. Smooth variations in opacity do not mix well with this format.
	['DXT3'] = 2,
	---The DXT5 format. RGBA data at 8 bits per pixel. Recommended for images with varying opacity on desktop systems.
	['DXT5'] = 3,
	---The BC4 format (also known as 3Dc+ or ATI1.) Stores just the red channel, at 4 bits per pixel.
	['BC4'] = 4,
	---The signed variant of the BC4 format. Same as above but pixel values in the texture are in the range of 1 instead of 1 in shaders.
	['BC4s'] = 5,
	---The BC5 format (also known as 3Dc or ATI2.) Stores red and green channels at 8 bits per pixel.
	['BC5'] = 6,
	---The signed variant of the BC5 format.
	['BC5s'] = 7,
	---The BC6H format. Stores half-precision floating-point RGB data in the range of 65504 at 8 bits per pixel. Suitable for HDR images on desktop systems.
	['BC6h'] = 8,
	---The signed variant of the BC6H format. Stores RGB data in the range of +65504.
	['BC6hs'] = 9,
	---The BC7 format (also known as BPTC.) Stores RGB or RGBA data at 8 bits per pixel.
	['BC7'] = 10,
	---The ETC1 format. RGB data at 4 bits per pixel. Suitable for fully opaque images on older Android devices.
	['ETC1'] = 11,
	---The RGB variant of the ETC2 format. RGB data at 4 bits per pixel. Suitable for fully opaque images on newer mobile devices.
	['ETC2rgb'] = 12,
	---The RGBA variant of the ETC2 format. RGBA data at 8 bits per pixel. Recommended for images with varying opacity on newer mobile devices.
	['ETC2rgba'] = 13,
	---The RGBA variant of the ETC2 format where pixels are either fully transparent or fully opaque. RGBA data at 4 bits per pixel.
	['ETC2rgba1'] = 14,
	---The single-channel variant of the EAC format. Stores just the red channel, at 4 bits per pixel.
	['EACr'] = 15,
	---The signed single-channel variant of the EAC format. Same as above but pixel values in the texture are in the range of 1 instead of 1 in shaders.
	['EACrs'] = 16,
	---The two-channel variant of the EAC format. Stores red and green channels at 8 bits per pixel.
	['EACrg'] = 17,
	---The signed two-channel variant of the EAC format.
	['EACrgs'] = 18,
	---The 2 bit per pixel RGB variant of the PVRTC1 format. Stores RGB data at 2 bits per pixel. Textures compressed with PVRTC1 formats must be square and power-of-two sized.
	['PVR1rgb2'] = 19,
	---The 4 bit per pixel RGB variant of the PVRTC1 format. Stores RGB data at 4 bits per pixel.
	['PVR1rgb4'] = 20,
	---The 2 bit per pixel RGBA variant of the PVRTC1 format.
	['PVR1rgba2'] = 21,
	---The 4 bit per pixel RGBA variant of the PVRTC1 format.
	['PVR1rgba4'] = 22,
	---The 4x4 pixels per block variant of the ASTC format. RGBA data at 8 bits per pixel.
	['ASTC4x4'] = 23,
	---The 5x4 pixels per block variant of the ASTC format. RGBA data at 6.4 bits per pixel.
	['ASTC5x4'] = 24,
	---The 5x5 pixels per block variant of the ASTC format. RGBA data at 5.12 bits per pixel.
	['ASTC5x5'] = 25,
	---The 6x5 pixels per block variant of the ASTC format. RGBA data at 4.27 bits per pixel.
	['ASTC6x5'] = 26,
	---The 6x6 pixels per block variant of the ASTC format. RGBA data at 3.56 bits per pixel.
	['ASTC6x6'] = 27,
	---The 8x5 pixels per block variant of the ASTC format. RGBA data at 3.2 bits per pixel.
	['ASTC8x5'] = 28,
	---The 8x6 pixels per block variant of the ASTC format. RGBA data at 2.67 bits per pixel.
	['ASTC8x6'] = 29,
	---The 8x8 pixels per block variant of the ASTC format. RGBA data at 2 bits per pixel.
	['ASTC8x8'] = 30,
	---The 10x5 pixels per block variant of the ASTC format. RGBA data at 2.56 bits per pixel.
	['ASTC10x5'] = 31,
	---The 10x6 pixels per block variant of the ASTC format. RGBA data at 2.13 bits per pixel.
	['ASTC10x6'] = 32,
	---The 10x8 pixels per block variant of the ASTC format. RGBA data at 1.6 bits per pixel.
	['ASTC10x8'] = 33,
	---The 10x10 pixels per block variant of the ASTC format. RGBA data at 1.28 bits per pixel.
	['ASTC10x10'] = 34,
	---The 12x10 pixels per block variant of the ASTC format. RGBA data at 1.07 bits per pixel.
	['ASTC12x10'] = 35,
	---The 12x12 pixels per block variant of the ASTC format. RGBA data at 0.89 bits per pixel.
	['ASTC12x12'] = 36,
}
---Encoded image formats.
ImageFormat = {
	---Targa image format.
	['tga'] = 1,
	---PNG image format.
	['png'] = 2,
	---JPG image format.
	['jpg'] = 3,
	---BMP image format.
	['bmp'] = 4,
}
---Pixel formats for Textures, ImageData, and CompressedImageData.
PixelFormat = {
	---Indicates unknown pixel format, used internally.
	['unknown'] = 1,
	---Alias for rgba8, or srgba8 if gamma-correct rendering is enabled.
	['normal'] = 2,
	---A format suitable for high dynamic range content - an alias for the rgba16f format, normally.
	['hdr'] = 3,
	---Single-channel (red component) format (8 bpp).
	['r8'] = 4,
	---Two channels (red and green components) with 8 bits per channel (16 bpp).
	['rg8'] = 5,
	---8 bits per channel (32 bpp) RGBA. Color channel values range from 0-255 (0-1 in shaders).
	['rgba8'] = 6,
	---gamma-correct version of rgba8.
	['srgba8'] = 7,
	---Single-channel (red component) format (16 bpp).
	['r16'] = 8,
	---Two channels (red and green components) with 16 bits per channel (32 bpp).
	['rg16'] = 9,
	---16 bits per channel (64 bpp) RGBA. Color channel values range from 0-65535 (0-1 in shaders).
	['rgba16'] = 10,
	---Floating point single-channel format (16 bpp). Color values can range from [-65504, +65504].
	['r16f'] = 11,
	---Floating point two-channel format with 16 bits per channel (32 bpp). Color values can range from [-65504, +65504].
	['rg16f'] = 12,
	---Floating point RGBA with 16 bits per channel (64 bpp). Color values can range from [-65504, +65504].
	['rgba16f'] = 13,
	---Floating point single-channel format (32 bpp).
	['r32f'] = 14,
	---Floating point two-channel format with 32 bits per channel (64 bpp).
	['rg32f'] = 15,
	---Floating point RGBA with 32 bits per channel (128 bpp).
	['rgba32f'] = 16,
	---Same as rg8, but accessed as (L, L, L, A)
	['la8'] = 17,
	---4 bits per channel (16 bpp) RGBA.
	['rgba4'] = 18,
	---RGB with 5 bits each, and a 1-bit alpha channel (16 bpp).
	['rgb5a1'] = 19,
	---RGB with 5, 6, and 5 bits each, respectively (16 bpp). There is no alpha channel in this format.
	['rgb565'] = 20,
	---RGB with 10 bits per channel, and a 2-bit alpha channel (32 bpp).
	['rgb10a2'] = 21,
	---Floating point RGB with 11 bits in the red and green channels, and 10 bits in the blue channel (32 bpp). There is no alpha channel. Color values can range from [0, +65024].
	['rg11b10f'] = 22,
	---No depth buffer and 8-bit stencil buffer.
	['stencil8'] = 23,
	---16-bit depth buffer and no stencil buffer.
	['depth16'] = 24,
	---24-bit depth buffer and no stencil buffer.
	['depth24'] = 25,
	---32-bit float depth buffer and no stencil buffer.
	['depth32f'] = 26,
	---24-bit depth buffer and 8-bit stencil buffer.
	['depth24stencil8'] = 27,
	---32-bit float depth buffer and 8-bit stencil buffer.
	['depth32fstencil8'] = 28,
	---The DXT1 format. RGB data at 4 bits per pixel (compared to 32 bits for ImageData and regular Images.) Suitable for fully opaque images on desktop systems.
	['DXT1'] = 29,
	---The DXT3 format. RGBA data at 8 bits per pixel. Smooth variations in opacity do not mix well with this format.
	['DXT3'] = 30,
	---The DXT5 format. RGBA data at 8 bits per pixel. Recommended for images with varying opacity on desktop systems.
	['DXT5'] = 31,
	---The BC4 format (also known as 3Dc+ or ATI1.) Stores just the red channel, at 4 bits per pixel.
	['BC4'] = 32,
	---The signed variant of the BC4 format. Same as above but pixel values in the texture are in the range of 1 instead of 1 in shaders.
	['BC4s'] = 33,
	---The BC5 format (also known as 3Dc or ATI2.) Stores red and green channels at 8 bits per pixel.
	['BC5'] = 34,
	---The signed variant of the BC5 format.
	['BC5s'] = 35,
	---The BC6H format. Stores half-precision floating-point RGB data in the range of 65504 at 8 bits per pixel. Suitable for HDR images on desktop systems.
	['BC6h'] = 36,
	---The signed variant of the BC6H format. Stores RGB data in the range of +65504.
	['BC6hs'] = 37,
	---The BC7 format (also known as BPTC.) Stores RGB or RGBA data at 8 bits per pixel.
	['BC7'] = 38,
	---The ETC1 format. RGB data at 4 bits per pixel. Suitable for fully opaque images on older Android devices.
	['ETC1'] = 39,
	---The RGB variant of the ETC2 format. RGB data at 4 bits per pixel. Suitable for fully opaque images on newer mobile devices.
	['ETC2rgb'] = 40,
	---The RGBA variant of the ETC2 format. RGBA data at 8 bits per pixel. Recommended for images with varying opacity on newer mobile devices.
	['ETC2rgba'] = 41,
	---The RGBA variant of the ETC2 format where pixels are either fully transparent or fully opaque. RGBA data at 4 bits per pixel.
	['ETC2rgba1'] = 42,
	---The single-channel variant of the EAC format. Stores just the red channel, at 4 bits per pixel.
	['EACr'] = 43,
	---The signed single-channel variant of the EAC format. Same as above but pixel values in the texture are in the range of 1 instead of 1 in shaders.
	['EACrs'] = 44,
	---The two-channel variant of the EAC format. Stores red and green channels at 8 bits per pixel.
	['EACrg'] = 45,
	---The signed two-channel variant of the EAC format.
	['EACrgs'] = 46,
	---The 2 bit per pixel RGB variant of the PVRTC1 format. Stores RGB data at 2 bits per pixel. Textures compressed with PVRTC1 formats must be square and power-of-two sized.
	['PVR1rgb2'] = 47,
	---The 4 bit per pixel RGB variant of the PVRTC1 format. Stores RGB data at 4 bits per pixel.
	['PVR1rgb4'] = 48,
	---The 2 bit per pixel RGBA variant of the PVRTC1 format.
	['PVR1rgba2'] = 49,
	---The 4 bit per pixel RGBA variant of the PVRTC1 format.
	['PVR1rgba4'] = 50,
	---The 4x4 pixels per block variant of the ASTC format. RGBA data at 8 bits per pixel.
	['ASTC4x4'] = 51,
	---The 5x4 pixels per block variant of the ASTC format. RGBA data at 6.4 bits per pixel.
	['ASTC5x4'] = 52,
	---The 5x5 pixels per block variant of the ASTC format. RGBA data at 5.12 bits per pixel.
	['ASTC5x5'] = 53,
	---The 6x5 pixels per block variant of the ASTC format. RGBA data at 4.27 bits per pixel.
	['ASTC6x5'] = 54,
	---The 6x6 pixels per block variant of the ASTC format. RGBA data at 3.56 bits per pixel.
	['ASTC6x6'] = 55,
	---The 8x5 pixels per block variant of the ASTC format. RGBA data at 3.2 bits per pixel.
	['ASTC8x5'] = 56,
	---The 8x6 pixels per block variant of the ASTC format. RGBA data at 2.67 bits per pixel.
	['ASTC8x6'] = 57,
	---The 8x8 pixels per block variant of the ASTC format. RGBA data at 2 bits per pixel.
	['ASTC8x8'] = 58,
	---The 10x5 pixels per block variant of the ASTC format. RGBA data at 2.56 bits per pixel.
	['ASTC10x5'] = 59,
	---The 10x6 pixels per block variant of the ASTC format. RGBA data at 2.13 bits per pixel.
	['ASTC10x6'] = 60,
	---The 10x8 pixels per block variant of the ASTC format. RGBA data at 1.6 bits per pixel.
	['ASTC10x8'] = 61,
	---The 10x10 pixels per block variant of the ASTC format. RGBA data at 1.28 bits per pixel.
	['ASTC10x10'] = 62,
	---The 12x10 pixels per block variant of the ASTC format. RGBA data at 1.07 bits per pixel.
	['ASTC12x10'] = 63,
	---The 12x12 pixels per block variant of the ASTC format. RGBA data at 0.89 bits per pixel.
	['ASTC12x12'] = 64,
}
---Determines whether a file can be loaded as CompressedImageData.
---@param filename string @The filename of the potentially compressed image file.
---@return boolean
---@overload fun(fileData:FileData):boolean
function m.isCompressed(filename) end

---Create a new CompressedImageData object from a compressed image file. LÖVE supports several compressed texture formats, enumerated in the CompressedImageFormat page.
---@param filename string @The filename of the compressed image file.
---@return CompressedImageData
---@overload fun(fileData:FileData):CompressedImageData
function m.newCompressedData(filename) end

---Creates a new ImageData object.
---@param width number @The width of the ImageData.
---@param height number @The height of the ImageData.
---@return ImageData
---@overload fun(width:number, height:number, format:PixelFormat, data:string):ImageData
---@overload fun(width:number, height:number, data:string):ImageData
---@overload fun(filename:string):ImageData
---@overload fun(filedata:FileData):ImageData
function m.newImageData(width, height) end

return m