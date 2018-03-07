attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

varying lowp vec4 PositionOut;

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Position;
    PositionOut = Position;
    TexCoordOut = TexCoordIn;
}