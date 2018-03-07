varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

varying highp float UseTextureOut;

void main(void) {
    if(UseTextureOut != 0.0)
        gl_FragColor = texture2D(Texture, TexCoordOut);
    else
        gl_FragColor = DestinationColor;

}