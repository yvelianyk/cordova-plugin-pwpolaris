attribute vec4 Position;
attribute vec4 SourceColor;
attribute float UseTextureIn;

varying vec4 DestinationColor;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

varying highp float UseTextureOut;

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Position;
    TexCoordOut = TexCoordIn;
    UseTextureOut = UseTextureIn;
}